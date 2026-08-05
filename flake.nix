{
  description = "Nix Config";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-26.05";
      # rev = "34627c90f062da515ea358360f448da57769236e";
    };
    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
      # rev = "3016b4b15d13f3089db8a41ef937b13a9e33a8df";
    };
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  }: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;

    system = "x86_64-linux";
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});

    # Formatter for your nix files, available through 'nix fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs nixpkgs;};

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'

    nixosConfigurations = {
      pc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs system;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
            config.cudaSupport = false;

            android_sdk.accept_license = true;
          };
          hardware-config = "pc";
          use-cuda = false;
          is-pc = true;
          is-worktop = false;
          is-wsl = false;
          is-fastop = false;
          stateVersion = "24.05";
        };
        modules = [
          ./nixos/configuration.nix
        ];
      };
      fastop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs system;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
            android_sdk.accept_license = true;
          };
          hardware-config = "fastop";
          use-cuda = false;
          is-pc = false;
          is-worktop = false;
          is-wsl = false;
          is-fastop = true;
          stateVersion = "24.05";
        };
        modules = [
          ./nixos/configuration.nix
        ];
      };
      worktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs system;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
            android_sdk.accept_license = true;
          };
          hardware-config = "worktop";
          use-cuda = false;
          is-pc = false;
          is-worktop = true;
          is-wsl = false;
          is-fastop = false;
          stateVersion = "24.05";
        };
        modules = [
          ./nixos/configuration.nix
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs system;
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
            android_sdk.accept_license = true;
          };
          hardware-config = "wsl";
          use-cuda = false;
          is-pc = false;
          is-worktop = false;
          is-wsl = true;
          is-fastop = false;
          stateVersion = "25.11";
        };
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };
  };
}
