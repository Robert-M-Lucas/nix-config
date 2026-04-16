#!/usr/bin/env bash

template="${1:-empty}"

if [[ "$template" == "libs" ]]; then
  cat > .envrc <<'EOF'
use flake
EOF
  cat > flake.nix <<'EOF'
{
  description = "A Flake";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-25.11";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ ];
        };

        packages = with pkgs; [
          pkg-config
          gcc
          libusb1
          glib
          krb5
          libcxx
        
        ];

        nativeBuildPackages = with pkgs; [
          pkg-config
          libusb1
          glib
          gcc
          krb5
          
          libcxx
        ];

        libraries = with pkgs; [
          libusb1
          glib
          krb5
          libcxx
          gcc.cc.lib        
      ];

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = packages;

          nativeBuildInputs = nativeBuildPackages;

          shellHook = with pkgs; ''
            export LD_LIBRARY_PATH="${lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH"

            export PATH=$PWD/bin:$PATH
          '';
        };
      }
    );
}
EOF
  echo "Created flake.nix in current directory."
else
  nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#${template}"
fi