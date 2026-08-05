{
  description = "Nix Config";

  inputs = {
    # Expand to add 'rev' if a specific commit is needed
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    system = "x86_64-linux";
    
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        cudaSupport = false;
        android_sdk.accept_license = true;
      };
    };

    forAllSystems = nixpkgs.lib.genAttrs systems;
    mkSystem = host: stateVersion: nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs outputs system pkgs-unstable;
        hardware-config = host;
        use-cuda = false;
        is-pc = host == "pc";
        is-worktop = host == "worktop";
        is-wsl = host == "wsl";
        is-fastop = host == "fastop";
        inherit stateVersion;
      };
      modules = [ ./nixos/configuration.nix ];
    };
    
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
      pc = mkSystem "pc" "24.05";
      fastop = mkSystem "fastop" "24.05";
      worktop = mkSystem "worktop" "24.05";
      wsl = mkSystem "wsl" "25.11";
    };
  };
}
