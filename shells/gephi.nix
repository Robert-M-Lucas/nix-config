{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = [
    pkgs.awscli
  ];

  nativeBuildInputs = [ 
    pkgs.awscli
  ];
}