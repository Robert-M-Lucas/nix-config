# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    pkgs-unstable,
    system,
    hardware-config,
    use-cuda,
    lite,
    overlays,
    overlays-unstable,
    ...
}: 
let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
    # You can import other NixOS modules here
    imports = [
        inputs.home-manager.nixosModules.home-manager

        # If you want to use modules your own flake exports (from modules/nixos):
        # outputs.nixosModules.example

        # Or modules from other flakes (such as nixos-hardware):
        # inputs.hardware.nixosModules.common-cpu-amd
        # inputs.hardware.nixosModules.common-ssd

        # You can also split up your configuration and import pieces of it here:
        # ./users.nix

        # Import your generated (nixos-generate-config) hardware configuration
        ./${hardware-config}/hardware-configuration.nix
    ];

    home-manager = {
        extraSpecialArgs = { inherit inputs outputs system pkgs-unstable use-cuda overlays overlays-unstable lite; };
        users = {
            # Import your home-manager configuration
            robert = import ../home-manager/home.nix;
        };
        backupFileExtension = "backup";
    };

    # Bootloader.
    # boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    
    boot.loader.grub = {
        enable = true;
        useOSProber = true;
        devices = [ "nodev" ];
        efiSupport = true;

        extraEntries= ''
        menuentry "UEFI Settings" {
            fwsetup
        }

        menuentry "Shutdown" {
            halt
        }
        '';

        theme = pkgs.stdenv.mkDerivation {
            pname = "distro-grub-themes";
            version = "3.1";
            src = pkgs.fetchFromGitHub {
                owner = "AdisonCavani";
                repo = "distro-grub-themes";
                rev = "v3.1";
                hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
            };
            installPhase = "cp -r customize/nixos $out";
        };
    };

    swapDevices = [ 
        { 
            device = "/swapfile";
            size = if lite then 8 * 1024 else 24 * 1024; 
        }
    ];

    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 8081 5173 22 ];
        allowedUDPPorts = [ 8081 5173 22 ];
    };

    nixpkgs = {
        # You can add overlays here
        overlays = [
            # Add overlays your own flake exports (from overlays and pkgs dir):
            outputs.overlays.additions
            outputs.overlays.modifications
            # outputs.overlays.unstable-packages

            # You can also add overlays exported from other flakes:
            # neovim-nightly-overlay.overlays.default

            # Or define it inline, for example:
            # (final: prev: {
            #     hi = final.hello.overrideAttrs (oldAttrs: {
            #         patches = [ ./change-hello-to-hi.patch ];
            #     });
            # })
        ];
        # Configure your nixpkgs instance
        config = {
            # Disable if you don't want unfree packages
            allowUnfree = true;
            android_sdk.accept_license = true;
        };
    };

    nix = let
        flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
        settings = {
            # Enable flakes and new 'nix' command
            experimental-features = "nix-command flakes";
            # Opinionated: disable global registry
            flake-registry = "";
            # Workaround for https://github.com/NixOS/nix/issues/9574
            # nix-path = config.nix.nixPath;
            # max-jobs = if lite then 1 else "auto";
        };
        # Opinionated: disable channels
        # channel.enable = false; 

        # Opinionated: make flake registry and nix path match flake inputs
        registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
        nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    # i18n.inputMethod.enabled = "ibus"; # Enables Super + . emoji picker

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.excludePackages = [ pkgs.xterm ];

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "gb";
        variant = "";
    };

    # Configure console keymap
    console.keyMap = "uk";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    programs.git.enable = true;

    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
        configure = {
            customRC = ''
                syntax on                       " Enable syntax highlighting
                filetype plugin indent on       " Indent based of file type
                let mapleader = " "
                set nocompatible
                set showcmd
                set noswapfile
                set noerrorbells
                set laststatus=2
                set mouse=a                     " Allow mouse to move the cursor
                set cursorline                  " Highlight the line under the cursor
                set clipboard+=unnamedplus      " Use system clipboard as primary register
                set shortmess=I                 " Prevent Vim startup screen
                set backspace=indent,eol,start  " Fix backspace in Insert mode
                set nowrap                      " Do not wrap lines
                set ic
                set sc
                set tabstop=4
                set shiftwidth=4
                set softtabstop=4
                set expandtab                   " Expand a tab key into spaces
                set autoindent                  " Simple indentation for text files
                set number                      " Display line number
                set relativenumber              " Display line numbers relative to cursor
                set hidden                      " Allow hidden buffers (more than one tab)
                set exrc                        " Execute .vimrc in project directory
                set secure                      " .vimrc in project directory can not run system commands
                set textwidth=100
                set completeopt-=preview
                set nobackup                    " Recommended by CoC
                set nowritebackup
                set wildchar=<Tab>
                set wildmenu
                set wildmode=full
                set shell=fish
                set background=dark
                colorscheme gruvbox

                nnoremap ff <cmd>Telescope find_files<cr>
                nnoremap fg <cmd>Telescope live_grep<cr>
                nnoremap fb <cmd>Telescope buffers<cr>
                nnoremap fh <cmd>Telescope help_tags<cr>
            '';

            packages.myVimPackage = with pkgs.vimPlugins; {
                start = [ 
                    nerdtree
                    coc-nvim
                    coc-rust-analyzer
                    plenary-nvim
                    telescope-nvim
                    telescope-fzf-native-nvim
                    vista-vim
                    project-nvim
                    vim-polyglot
                    wgsl-vim
                    vim-commentary
                    nvim-surround
                    quick-scope
                    auto-pairs
                    vim-signature
                    vim-airline
                    vim-airline-themes
                    rainbow #
                    vim-devicons
                    vim-nerdtree-syntax-highlight
                    gruvbox-nvim
                ];
            };
        };
    };

    # Move to home-manager if possible
    # programs.steam.enable = true;

    programs.spicetify = {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
            adblockify
            shuffle
            fullAppDisplayMod
            popupLyrics
            beautifulLyrics
        ];
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "frappe";
    };

    programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
            stdenv.cc.cc.lib
        ];
    };

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    environment.systemPackages = with pkgs; [
	    tmux
        fprintd
        fastfetch
        nixVersions.latest
        mutter
        # python3
        gcc
        usbutils
        # home-manager

        wget
        gnumake
        go

        protonvpn-gui
        google-chrome

        # TODO: TEMP
        # flutter
        # dart
        jdk17

        (writeShellScriptBin "nix-env" (builtins.readFile ./nonixenv.sh))
    ];

    fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    environment.gnome.excludePackages = (with pkgs; [
        # for packages that are pkgs.*
        gnome-tour
        gnome-connections
    ]) ++ (with pkgs; [
        # for packages that are pkgs.gnome.*
        epiphany # web browser
        geary # email reader
        yelp
        seahorse
        gnome-clocks
        gnome-maps
        gnome-weather
        # evince # document viewer
    ]);

    services.fprintd.enable = true;
    services.fprintd.tod.enable = true;
    # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
    services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;


    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #     enable = true;
    #     enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # networking.wireless.enable = true;    # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;
    networking.hostName = "nixos";

    # This setups a SSH server. Very important if you're setting up a headless system.
    # Feel free to remove if you don't need it.
    services.openssh = {
        enable = true;
        allowSFTP = true;
        ports = [ 22 ];
        settings = {
            # Opinionated: forbid root login through SSH.
            PermitRootLogin = "no";
            # Opinionated: use keys only.
            # Remove if you want to SSH using passwords
            PasswordAuthentication = true;
            AllowUsers = ["demo"];
        };
    };

    programs.bash = {
        interactiveShellInit = ''
            if [[ -x ${pkgs.fish}/bin/fish && $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
            then
                shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
                exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
            fi
        '';
    };

    programs.captive-browser.enable = true;
    programs.captive-browser.interface = "wlp2s0";

    # Configure your system-wide user settings (groups, etc), add more users as needed.
    users.users = {
        robert = {
            # You can set an initial password for your user.
            # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
            # Be sure to change it (using passwd) after rebooting!
            # initialPassword = "correcthorsebatterystaple";
            description = "Robert Lucas";
            isNormalUser = true;
            openssh.authorizedKeys.keys = [
                # Add your SSH public key(s) here, if you plan on using SSH to connect
            ];
            # Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
            extraGroups = ["wheel" "networkmanager" "docker"];
        };
        # demo = {
        #     description = "Demo User for SSH";
        #     isNormalUser = true;
        # };
        # temp = {
        #     isNormalUser=true;
        #     password="";
        #     extraGroups = ["wheel" "networkmanager" "docker"];
        # };
    };

    users.groups.libvirtd.members = ["robert"];

    # ? Last time running `nix-store --optimise` it only saved ~7GB for a very long execution time
    # nix.settings.auto-optimise-store = true;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    system.stateVersion = "24.05";
}
