# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-jb-fix,
  system,
  hardware-config,
  use-cuda,
  is-pc,
  is-worktop,
  overlays,
  overlays-unstable,
  ...
}: let
  # spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./${hardware-config}/hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      # outputs.overlays.unstable-packages
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      cudaSupport = use-cuda;
      android_sdk.accept_license = true;
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs system pkgs-unstable pkgs-jb-fix use-cuda overlays overlays-unstable is-pc is-worktop;};
    users = {
      # Import your home-manager configuration
      robert = import ../home-manager/home.nix;
    };
    backupFileExtension = "backup_v2";
  };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["nfs"];

  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    devices = ["nodev"];
    efiSupport = true;
    configurationLimit =
      if is-worktop
      then 2
      else 100;

    extraEntries = ''
      menuentry "UEFI Settings" {
          fwsetup
      }

      menuentry "Shutdown" {
          halt
      }
    '';

    # theme =
    #   if is-worktop
    #   then null
    #   else
    #     pkgs.stdenv.mkDerivation {
    #       pname = "distro-grub-themes";
    #       version = "3.2";
    #       src = pkgs.fetchFromGitHub {
    #         owner = "AdisonCavani";
    #         repo = "distro-grub-themes";
    #         rev = "v3.1";
    #         hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
    #       };
    #       installPhase = "cp -r customize/nixos $out";
    #     };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 24 * 1024;
    }
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts =
      if is-worktop
      then []
      else [8081 5173 22];
    allowedUDPPorts =
      if is-worktop
      then []
      else [8081 5173 22];
    trustedInterfaces =
      if is-worktop
      then []
      else ["tailscale0"];
  };

  security.pam.services.sshd.googleAuthenticator.enable = true;

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";

      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
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
  services.xserver.excludePackages = [pkgs.xterm];

  # Enable plasma
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;

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
  services.pulseaudio.enable = false;
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

  programs.virt-manager.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_25;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
  ];

  users.users = {
    robert = {
      description = "Robert Lucas";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = ["wheel" "networkmanager" "docker" "i2c"];
    };
    guest = {
      description = "Guest";
      password = "guest";
      isNormalUser = true;
      extraGroups = ["networkmanager"];
    };
    temp = {
      isNormalUser = true;
      extraGroups = ["networkmanager"];
    };
  };

  users.groups.libvirtd.members = ["robert"];

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

  networking.networkmanager.enable = true;

  services.openssh = {
    enable = true;
    allowSFTP = true;
    ports = [22];
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
      AllowUsers = ["robert"];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        # "hmac-sha2-512" # Might be less secure - needed for dartssh2
      ];
    };
  };

  # Programs

  systemd.services.NetworkManager-wait-online.enable = false;

  services.tailscale = {
    enable = !is-worktop;
    useRoutingFeatures = "client"; # acts as client only
    openFirewall = true; # open Tailscale ports
  };

  environment.systemPackages = let
    systemPackages = with pkgs;
      [
        sweet-nova

        tmux
        fprintd
        fastfetch
        htop
        nixVersions.latest
        gcc
        gdb
        usbutils

        wget
        gnumake
        go
        dig
        ripgrep
        config.boot.kernelPackages.perf

        firefox-bin # No, we don't need another package built from source

        protonvpn-gui
        google-chrome
        libreoffice
        thunderbird-bin
        ddcutil

        (writeShellScriptBin "nix-env" (builtins.readFile ./nonixenv.sh))
      ]
      ++ (
        if is-worktop
        then []
        else [
          krita
          gimp
          obs-studio
          blender
          musescore

          jdk17
        ]
      );

    unstableSystemPackages = with pkgs-unstable; [
      obsidian
    ];
  in
    systemPackages ++ unstableSystemPackages;

  programs.gnome-terminal.enable = true;
  console.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany # web browser
    geary # email reader
    yelp # help viewer
    gnome-maps
    gnome-weather
    gnome-system-monitor
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];
  };

  programs.steam = {
    enable = !is-worktop;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.git.enable = true;

  # TODO reenable
  # programs.kdeconnect = {
  #   enable = true;
  #   package = pkgs.gnomeExtensions.gsconnect;
  # };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = false;
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
