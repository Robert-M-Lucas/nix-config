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
      

  # ====== CMD ======
      # oh-my-fish
      # gh
      rustup
      cloc
      neovim
      xclip
      nodejs_22
      wolfram-engine
      ffmpeg

      (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
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
      # gnomeExtensions.custom-accent-colors
      
      # graphite-gtk-theme
      # gtk-engine-murrine
      # gnome.gnome-themes-extra

  # ====== Other ======
      diff-so-fancy
    ];

    y = with pkgs-unstable; [
      discord
      discordo
    ];
  in
    x ++ y;
}