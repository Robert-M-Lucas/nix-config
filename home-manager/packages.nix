{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    vscodium
    google-chrome
    oh-my-fish
    gnomeExtensions.ddterm
  ];
}