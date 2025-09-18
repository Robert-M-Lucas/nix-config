{
  description = "Nix Config";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-25.05";
      # rev = "34627c90f062da515ea358360f448da57769236e";
    };
    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
      # rev = "3016b4b15d13f3089db8a41ef937b13a9e33a8df";
    };
    nixpkgs-jb-fix = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-25.05";
    };
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-jb-fix,
    # catppuccin,
    home-manager,
    # spicetify-nix,
    ...
  }: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "x86_64-linux"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;

    system = "x86_64-linux";
  in
    with inputs; {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays {inherit inputs nixpkgs;};

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        pc = nixpkgs.lib.nixosSystem {
          # pkgs = import nixpkgs { inherit system; };
          specialArgs = {
            inherit inputs outputs system;
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
              config.cudaSupport = true;
              android_sdk.accept_license = true;
            };
            pkgs-jb-fix = import nixpkgs-jb-fix {
              inherit system;
              config.allowUnfree = true;
              config.cudaSupport = true;
              android_sdk.accept_license = true;
            };
            hardware-config = "pc";
            use-cuda = true;
            is-pc = true;
          };
          modules = [
            # > Our main nixos configuration file <
            # catppuccin.nixosModules.catppuccin
            ./nixos/configuration.nix
            # spicetify-nix.nixosModules.default
          ];
        };
        fastop = nixpkgs.lib.nixosSystem {
          # pkgs = import nixpkgs { inherit system; };
          specialArgs = {
            inherit inputs outputs system;
            pkgs-unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
              android_sdk.accept_license = true;
            };
            pkgs-jb-fix = import nixpkgs-jb-fix {
              inherit system;
              config.allowUnfree = true;
              config.cudaSupport = true;
              android_sdk.accept_license = true;
            };
            hardware-config = "fastop";
            use-cuda = false;
            is-pc = false;
          };
          modules = [
            # > Our main nixos configuration file <
            # catppuccin.nixosModules.catppuccin
            ./nixos/configuration.nix
            # spicetify-nix.nixosModules.default
          ];
        };
      };
    };
}
