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
    gnomeExtensions.ddterm
    (writeShellScriptBin "hi" (builtins.readFile ./scripts/nix-config.sh))
  ];
}