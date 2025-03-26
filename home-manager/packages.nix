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
  pythonEnv = pkgs.python311.withPackages (ps:
    with ps; [
      # torchWithCuda
      # Add your Python packages here
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

      # torch-bin
      # torchsde
      # torchvision-bin
      # torchaudio-bin
      # einops
      # transformers
      # tokenizers
      # sentencepiece
      # safetensors
      # aiohttp
      # pyyaml
      # pillow
      # scipy
      # tqdm
      # psutil
      # torchWithCuda

      #non essential dependencies:
      # kornia
      # spandrel
      # soundfile

      # Include libstdc++ for your environment
      # pkgs.libstdcxx5
    ]);
in {
  home.packages = let
    x = with pkgs; [
      # ====== GUI Apps ======
      libreoffice
      calibre
      obsidian
      pomodoro-gtk
      krita
      gimp
      obs-studio
      mediawriter
      rpi-imager
      darktable
      blender
      qalculate-gtk
      vesktop
      blender
      rare
      musescore
      insomnia
      alacarte
      prismlauncher
      gthumb
      amberol
      emblem
      spotify

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

      (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
      (writeShellScriptBin "nix-clean" (builtins.readFile ./scripts/nix-clean.sh))

      (writeShellScriptBin "rust-shell" (builtins.readFile ./scripts/rust-shell.sh))
      # (writeShellScriptBin "shell" (builtins.readFile ./scripts/shell.sh))
      # (writeShellScriptBin "shell-pure" (builtins.readFile ./scripts/shell-pure.sh))
      (writeShellScriptBin "shell-config" (builtins.readFile ./scripts/shell-config.sh))
      (writeShellScriptBin "neofetch" (builtins.readFile ./scripts/unneofetch.sh))
      (writeShellScriptBin "gitf" (builtins.readFile ./scripts/gitf.sh))

      # (writeShellScriptBin "cdd" (builtins.readFile ./scripts/cdd.sh))
      # (writeShellScriptBin "cdu" (builtins.readFile ./scripts/cdu.sh))

      # ====== IDEs ======
      jetbrains.rust-rover
      jetbrains.webstorm
      jetbrains.jdk
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.pycharm-community
      android-studio
      jetbrains.idea-ultimate

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
      # ====== IDEs ======
      # davinci-resolve
      # gephi
      discord
      # steam
    ];

    z = [
      # overlays.davinci-resolve
    ];

    non-lite = [
      pkgs.jetbrains.goland
      pkgs.jetbrains.rider
      # pkgs-unstable.zed-editor
      pkgs-unstable.davinci-resolve
      pkgs-unstable.muse-sounds-manager
      pkgs.wireshark
      # pkgs.virtualbox
      pkgs.virt-manager
      pkgs.arduino-ide
      pkgs-unstable.dotnet-sdk_9

      # ====== Shell Deps ====== (Prevent shells redownloading)

      pkgs.xorg.libX11
      pkgs.xorg.libXcursor
      pkgs.xorg.libXrandr
      pkgs.xorg.libXi
      pkgs.xorg.libxcb
      pkgs.libxkbcommon
      pkgs.alsa-lib
      pkgs.libudev-zero

      pkgs.SDL2

      pkgs.shaderc
      pkgs.directx-shader-compiler
      pkgs.libGL
      pkgs.vulkan-headers
      pkgs.vulkan-loader
      pkgs.vulkan-tools
      pkgs.vulkan-tools-lunarg
      pkgs.vulkan-validation-layers

      pkgs.openssl
      pkgs.pkg-config

      pkgs.alsa-lib
    ];
  in
    x
    ++ y
    ++ z
    ++ non-lite;
}
