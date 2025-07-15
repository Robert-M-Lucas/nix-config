{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
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
      libreoffice
      onlyoffice-bin
      obsidian
      gnome-solanum
      krita
      gimp
      obs-studio
      rpi-imager
      darktable
      blender
      qalculate-gtk
      blender
      musescore
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
      thunderbird

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
      wine

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

      # ====== IDEs ======
      jetbrains.rust-rover
      jetbrains.webstorm
      jetbrains.clion
      jetbrains.pycharm-professional
      android-studio
      jetbrains.idea-ultimate
    ];

    z = [
      
    ];

    non-lite = [
      pkgs-unstable.jetbrains.goland
      pkgs-unstable.jetbrains.rider
      pkgs-unstable.davinci-resolve
      pkgs-unstable.muse-sounds-manager
      pkgs.wireshark
      pkgs-unstable.arduino-ide
      pkgs-unstable.dotnet-sdk_9

      # ====== Shell Deps ====== (Prevent shells redownloading)

      # pkgs.xorg.libX11
      # pkgs.xorg.libXcursor
      # pkgs.xorg.libXrandr
      # pkgs.xorg.libXi
      # pkgs.xorg.libxcb
      # pkgs.libxkbcommon
      # pkgs.alsa-lib
      # pkgs.libudev-zero

      # pkgs.SDL2

      # pkgs.shaderc
      # pkgs.directx-shader-compiler
      # pkgs.libGL
      # pkgs.vulkan-headers
      # pkgs.vulkan-loader
      # pkgs.vulkan-tools
      # pkgs.vulkan-tools-lunarg
      # pkgs.vulkan-validation-layers

      # pkgs.openssl
      # pkgs.pkg-config

      # pkgs.alsa-lib
    ];
  in
    x
    ++ y
    ++ z
    ++ non-lite;
}
