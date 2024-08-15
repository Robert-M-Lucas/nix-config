{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
# ====== GUI Apps ======
    libreoffice
    google-chrome
    calibre
    obsidian
    protonvpn-gui
    pomodoro-gtk
    wireshark

# ====== CMD ======
    # oh-my-fish
    gh
    rustup
    cloc
    neovim

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

# ====== Other ======
    diff-so-fancy
  ];
}