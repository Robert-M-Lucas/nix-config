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

    vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        vscode-extensions.rust-lang.rust-analyzer
        vscode-extensions.jnoortheen.nix-ide
      ];
    }
  ];
}