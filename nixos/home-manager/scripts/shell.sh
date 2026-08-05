#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <shell-name>"
  exit 1
fi

nix-shell "/home/robert/nix-config/nixos/home-manager/scripts/shells/$1.nix"