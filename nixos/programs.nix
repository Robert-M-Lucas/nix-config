{
  pkgs,
  pkgs-unstable,
  is-worktop,
  is-wsl,
  ...
}: {
  # Programs
  environment.systemPackages = let
    systemPackages = with pkgs;
      [
        # All configs utils
        tmux
        fprintd
        fastfetch
        htop
        nixVersions.latest
        gcc
        gdb
        usbutils
        nettools
        nmap
        inetutils
        netcat-gnu
        hping
        nix-output-monitor
        wget
        gnumake
        go
        dig
        ripgrep
        perf
        btop
        clinfo
        pciutils
        libva-utils
        vulkan-tools
        radeontop
        lm_sensors
        mesa-demos
        file
        v4l-utils
        cowsay
        neovim

        (writeShellScriptBin "nix-env" (builtins.readFile ./scripts/nonixenv.sh))
      ]
      ++ (
        if is-wsl
        then []
        else [
          # --- Non-wsl ---
          # Dolphin
          kdePackages.dolphin
          kdePackages.qtsvg
          kdePackages.kio # needed since 25.11
          kdePackages.kio-fuse #to mount remote filesystems via FUSE
          kdePackages.kio-extras #extra protocols support (sftp, fish and more)
          kdePackages.qt6ct
          libsForQt5.qt5ct

          # Util
          qgnomeplatform
          ddcutil

          # GUI
          file-roller
          firefox-bin # No, we don't need another package built from source
          cheese
          seahorse
          proton-vpn
          google-chrome
          libreoffice
          thunderbird-bin
          krita
          gimp
          gthumb
          gnome-clocks
          resources
        ]
      )
      ++ (
        if is-worktop || is-wsl
        then []
        else [
          obs-studio
          blender
          musescore

          jdk17
        ]
      )
      ++ (
        if is-worktop
        then [
          # howdy
        ]
        else []
      );

    unstableSystemPackages = with pkgs-unstable;
      [
      ]
      ++ (
        if is-wsl
        then with pkgs-unstable; []
        else
          with pkgs-unstable; [
            obsidian
          ]
      );
  in
    systemPackages ++ unstableSystemPackages;
  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "gnome";

  programs.wireshark = {
    enable = !is-wsl;
    package = pkgs.wireshark;
  };

  programs.gnome-terminal.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany # web browser
    geary # email reader
    yelp # help viewer
    gnome-maps
    gnome-weather
    gnome-system-monitor
  ];

  virtualisation.docker.enable = !is-wsl;

  programs.virt-manager.enable = !is-wsl;
  virtualisation.libvirtd.enable = !is-wsl;
  virtualisation.spiceUSBRedirection.enable = !is-wsl;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];
  };

  programs.steam = {
    enable = !is-worktop && !is-wsl;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.git.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = false;
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

  programs.captive-browser.enable = !is-wsl;
  programs.captive-browser.interface = "wlp2s0";
}
