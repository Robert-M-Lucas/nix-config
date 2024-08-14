{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    google-chrome
    oh-my-fish
    gh

    jetbrains.rust-rover
    jetbrains.webstorm
    jetbrains.rider
    jetbrains.pycharm-professional
    jetbrains.jdk
    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.clion

    gnomeExtensions.ddterm
    gnomeExtensions.hide-top-bar

    (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
  ];
}