{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  nativeBuildInputs = [ 
    pkgs.gephi
    pkgs.zulu8
  ];
}