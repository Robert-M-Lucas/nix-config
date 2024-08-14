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

    gnomeExtensions.ddterm
    gnomeExtensions.hide-top-bar

    (writeShellScriptBin "nix-config" (builtins.readFile ./scripts/nix-config.sh))
  ];
}