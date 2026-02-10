{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-jb,
  use-cuda,
  home,
  is-pc,
  is-worktop,
  ...
}:
let
  pythonEnv = pkgs.python312.withPackages (
    ps:
    (
      if !is-worktop then
        with ps;
        [
          numpy
          scikit-learn
          jupyter
          matplotlib
          pooch
          opencv4
          ffmpeg-python
          pygobject3
          pygame
          scikit-image
          trimesh
          notebook
          beautifulsoup4
          lxml
          requests
          termcolor
          flask
          pynput
          pyautogui
          keyboard
          websockets
        ]
      else
        with ps;
        [
          numpy
          matplotlib
          west
          jsonschema
          tree-sitter
          tree-sitter-grammars.tree-sitter-c
          python-docx
          minify-html
          beautifulsoup4
        ]
    )
  );
in
{
  home.packages =
    let
      x = with pkgs; [
        # ====== GUI Apps ======
        onlyoffice-desktopeditors
        gnome-solanum
        qalculate-gtk
        insomnia
        alacarte
        gthumb
        amberol
        emblem
        spotify
        gnome-clocks
        impression
        smile
        resources
        hieroglyphic
        boxbuddy
        meld
        teams-for-linux

        # ====== IDEs ======
        arduino-ide

        # ====== CMD ======
        pythonEnv
        platformio-core
        clang-tools
        cmake
        ninja
        sl
        rustup
        cloc
        nasm
        fortune
        zip
        unzip
        xclip
        libqalculate
        pkg-config
        libudev-zero
        dconf2nix
        qemu
        spotdl
        lcov
        poetry
        nix-output-monitor
        valgrind
        pipes-rs
        cbonsai
        asciiquarium
        nyancat
        neo
        wineWowPackages.stableFull
        winetricks
        delta
        distrobox
        podman
        nodejs_22
        ffmpeg
        texlive.combined.scheme-full
        nixd
        nixfmt

        # ====== Scripts ======

        (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
        (writeShellScriptBin "nix-clean" (builtins.readFile ./scripts/nix-clean.sh))

        (writeShellScriptBin "rust-shell" (builtins.readFile ./scripts/rust-shell.sh))
        (writeShellScriptBin "shell-config" (builtins.readFile ./scripts/shell-config.sh))
        (writeShellScriptBin "neofetch" (builtins.readFile ./scripts/unneofetch.sh))
        (writeShellScriptBin "gitf" (builtins.readFile ./scripts/gitf.sh))
        (writeShellScriptBin "chx" (builtins.readFile ./scripts/chx.sh))
        (writeShellScriptBin "where" (builtins.readFile ./scripts/where.sh))
        (writeShellScriptBin "netports" (builtins.readFile ./scripts/netports.sh))
        (writeShellScriptBin "docker-nuke" (builtins.readFile ./scripts/docker-nuke.sh))
        (writeShellScriptBin "genpass" (builtins.readFile ./scripts/genpass.sh))

        (writeShellScriptBin "prores" (builtins.readFile ./scripts/prores.sh))
        (writeShellScriptBin "mp4" (builtins.readFile ./scripts/mp4.sh))
        (writeShellScriptBin "nft" (builtins.readFile ./scripts/nft.sh))

        (writeShellScriptBin "wbb" (builtins.readFile ./scripts/wbb.sh))
        (writeShellScriptBin "exp" (builtins.readFile ./scripts/exp.sh))
        (writeShellScriptBin "flameshot-gui" (builtins.readFile ./scripts/flameshot-gui.sh))

        # ====== Extensions ======
        gnome-shell-extensions
        gnomeExtensions.ddterm
        gnomeExtensions.hide-top-bar
        gnomeExtensions.caffeine
        gnomeExtensions.vitals
        gnomeExtensions.blur-my-shell
        gnomeExtensions.appindicator
        gnomeExtensions.color-picker
      ];

      y = with pkgs-unstable; [
      ];

      pc-only = [
      ];

      fastop-only = [
      ];

      non-work = [
        # ====== GUI Apps ======
        pkgs.prismlauncher
        pkgs.keypunch
        pkgs.unityhub
        pkgs.legendary-gl
        pkgs.cutechess

        pkgs-unstable.calibre
        pkgs-unstable.discord
        pkgs-unstable.darktable
        pkgs-unstable.muse-sounds-manager
        pkgs-unstable.upscayl

        # ====== CMD ======
        pkgs.google-cloud-sdk
        pkgs.gradle
        pkgs.diesel-cli
        pkgs.dotnet-sdk_9
        pkgs.android-tools
        pkgs.yt-dlp
        pkgs.fastchess
      ];

      work-only = [
        pkgs.subversion
        pkgs.gitkraken
        pkgs.glab
        pkgs-unstable.zensical
      ];

      jetbrains-ides = [
        pkgs-jb.jetbrains.rust-rover
        pkgs-jb.jetbrains.webstorm
        pkgs-jb.jetbrains.clion
        pkgs-jb.jetbrains.pycharm
        pkgs-jb.android-studio
        pkgs-jb.jetbrains.idea
        pkgs-jb.jetbrains.goland
        pkgs-jb.jetbrains.rider
      ];
    in
    x
    ++ y
    ++ (if !is-worktop then jetbrains-ides else [ ])
    ++ (if is-worktop then work-only else non-work)
    ++ (if is-pc then pc-only else fastop-only);
}
