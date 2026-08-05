# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  system,
  hardware-config,
  use-cuda,
  is-pc,
  is-worktop,
  is-wsl,
  is-fastop,
  overlays,
  overlays-unstable,
  stateVersion,
  ...
}: {
  # You can import other NixOS modules here
  imports =
    [
      ./hardware/${hardware-config}/hardware-configuration.nix
      ./common-hardware.nix

      ./nixpkgs.nix

      ./boot.nix

      ./de.nix # contains DE services
      ./users.nix
      ./networking.nix # contains networking services
      ./services.nix
      ./programs.nix

      inputs.home-manager.nixosModules.home-manager
    ]
    ++ (
      if is-wsl
      then [<nixos-wsl/modules>]
      else []
    );

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs system pkgs-unstable stateVersion use-cuda overlays overlays-unstable is-pc is-worktop is-fastop is-wsl;};
    users = {
      # Import your home-manager configuration
      robert = import ../home-manager/home.nix;
    };
    backupFileExtension = "backup_v2";
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";

      substituters = [
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    # Opinionated: disable channels
    # channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  system.stateVersion = stateVersion;
}
