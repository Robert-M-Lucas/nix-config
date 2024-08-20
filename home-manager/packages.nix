{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  home,
  ...
}: 
let
  # Adding the local file to the Nix store
  # wolframSH = builtins.fetchurl {
  #   url = "https://raw.githubusercontent.com/Robert-M-Lucas/nix-config/master/home-manager/assets/WolframEngine_13.3.0_LINUX.sh";
  #   sha256 = "96106ac8ed6d0e221a68d846117615c14025320f927e5e0ed95b1965eda68e31";
  # };

  # # Overriding the wolfram-engine package to include the file
  # customWolframEngine = pkgs.wolfram-engine.overrideAttrs (oldAttrs: {
  #   nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ wolframSH ];
  # });
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    # Add your Python packages here
    # numpy
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
      protonvpn-gui
      pomodoro-gtk
      wireshark
      arduino-ide
      zed-editor
      krita
      gimp
      obs-studio

  # ====== CMD ======
      # oh-my-fish
      # gh
      rustup
      cloc
      neovim
      xclip
      nodejs_22
      # wolfram-engine
      ffmpeg
      # clang
      # clang-tools
      # libgcc
      # gnumake
      # cmake
      # extra-cmake-modules
      # stdenv.cc.cc.lib
      pythonEnv
      # zoxide
      nasm

      (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
      (writeShellScriptBin "shell" (builtins.readFile ./scripts/shell.sh))
      (writeShellScriptBin "shell-config" (builtins.readFile ./scripts/shell-config.sh))
      (writeShellScriptBin "cdd" (builtins.readFile ./scripts/cdd.sh))
      (writeShellScriptBin "cdu" (builtins.readFile ./scripts/cdu.sh))

  # ====== IDEs ======
      jetbrains.rust-rover
      jetbrains.webstorm
      jetbrains.rider
      jetbrains.pycharm-professional
      jetbrains.jdk
      jetbrains.idea-ultimate
      jetbrains.goland
      jetbrains.clion
      android-studio

  # ====== Extensions ======
      gnomeExtensions.ddterm
      gnomeExtensions.hide-top-bar
      gnomeExtensions.caffeine
      gnomeExtensions.vitals
      gnomeExtensions.enhanced-osk
      # gnomeExtensions.custom-accent-colors
      
      # graphite-gtk-theme
      # gtk-engine-murrine
      # gnome.gnome-themes-extra

  # ====== Other ======
      diff-so-fancy
    ];

    y = with pkgs-unstable; [
      discord
    ];
  in
    x ++ y;
}