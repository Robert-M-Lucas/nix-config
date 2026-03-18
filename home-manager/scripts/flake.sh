#!/usr/bin/env bash

template="${1:-empty}"
nix flake init --template "https://flakehub.com/f/the-nix-way/dev-templates/*#${template}"