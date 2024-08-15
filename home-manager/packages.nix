{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = let 
    x = with pkgs; [
  # ====== GUI Apps ======
      libreoffice
      google-chrome
      calibre
      obsidian
      protonvpn-gui
      pomodoro-gtk
      wireshark
      arduino-ide
      zed-editor
      

  # ====== CMD ======
      # oh-my-fish
      gh
      rustup
      cloc
      neovim
      xclip

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