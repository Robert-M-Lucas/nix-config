{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-jb-fix,
  use-cuda,
  home,
  is-pc,
  is-worktop,
  ...
}: let
  pythonEnv = pkgs.python312.withPackages (
    ps: (
      if !is-worktop
      then
        with ps; [
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
      else with ps; [numpy matplotlib]
    )
  );
in {
  home.packages = let
    x = with pkgs; [
      # ====== GUI Apps ======
      onlyoffice-bin
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

      # ====== CMD ======
      pythonEnv
      platformio-core
      clang-tools
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

      (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
      (writeShellScriptBin "nix-clean" (builtins.readFile ./scripts/nix-clean.sh))

      (writeShellScriptBin "rust-shell" (builtins.readFile ./scripts/rust-shell.sh))
      (writeShellScriptBin "shell-config" (builtins.readFile ./scripts/shell-config.sh))
      (writeShellScriptBin "neofetch" (builtins.readFile ./scripts/unneofetch.sh))
      (writeShellScriptBin "gitf" (builtins.readFile ./scripts/gitf.sh))
      (writeShellScriptBin "chx" (builtins.readFile ./scripts/chx.sh))

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

      # ====== Other ======
      diff-so-fancy
    ];

    y = with pkgs-unstable; [
      wineWowPackages.staging

      # ====== IDEs ======
      wireshark
      arduino-ide
    ];

    pc-only = [
    ];

    fastop-only = [
      pkgs.calibre
    ];

    non-work = [
      # ====== GUI Apps ======
      pkgs.prismlauncher
      pkgs.keypunch
      pkgs.unityhub
      pkgs.legendary-gl

      pkgs-unstable.discord
      pkgs-unstable.darktable
      pkgs-unstable.muse-sounds-manager

      # ====== CMD ======
      pkgs.nodejs_22
      pkgs.ffmpeg
      pkgs.texlive.combined.scheme-full
      pkgs.google-cloud-sdk
      pkgs.gradle
      pkgs.diesel-cli
      pkgs.dotnet-sdk_9
      pkgs.android-tools
    ];

    jetbrains-ides = [
      pkgs.jetbrains.rust-rover
      pkgs.jetbrains.webstorm
      pkgs.jetbrains.clion
      pkgs.jetbrains.pycharm-professional
      pkgs.android-studio
      pkgs.jetbrains.idea-ultimate
      pkgs.jetbrains.goland
      pkgs.jetbrains.rider
    ];
  in
    x
    ++ y
    ++ (
      if !is-worktop
      then jetbrains-ides
      else []
    )
    ++ (
      if !is-worktop
      then non-work
      else []
    )
    ++ (
      if is-pc
      then pc-only
      else fastop-only
    );
}
