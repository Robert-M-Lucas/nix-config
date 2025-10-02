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
  ...
}: let
  pythonEnv = pkgs.python312.withPackages (ps:
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
    ]);
in {
  home.packages = let
    x = with pkgs; [
      # ====== GUI Apps ======
      onlyoffice-bin
      gnome-solanum
      rpi-imager
      qalculate-gtk
      insomnia
      alacarte
      prismlauncher
      gthumb
      amberol
      emblem
      spotify
      gnome-clocks
      keypunch
      impression
      wike
      smile
      lutris
      resources
      
      # ====== CMD ======
      platformio-core
      clang-tools
      sl
      rustup
      cloc
      nodejs_22
      ffmpeg
      pythonEnv
      nasm
      texlive.combined.scheme-full
      google-cloud-sdk
      fortune
      zip
      unzip
      xclip
      libqalculate
      gradle
      pkg-config
      libudev-zero
      legendary-gl
      dconf2nix
      qemu
      spotdl
      lcov
      android-tools
      poetry
      nix-output-monitor
      diesel-cli
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


      # ====== IDEs ======
      unityhub

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
      discord
      wineWowPackages.staging

      # ====== IDEs ======
      muse-sounds-manager
      wireshark
      arduino-ide
      dotnet-sdk_9
    ];

    pc-only = [
      
    ];

    fastop-only = [
      pkgs.calibre
    ];

    ides = with pkgs-jb-fix; [
      jetbrains.rust-rover
      jetbrains.webstorm
      jetbrains.clion
      jetbrains.pycharm-professional
      android-studio
      jetbrains.idea-ultimate
      jetbrains.goland
      jetbrains.rider
      davinci-resolve
    ];
  in
    x
    ++ y
    ++ ides
    ++ (if is-pc then pc-only else fastop-only);
}
