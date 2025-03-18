{
    description = "Nix Config";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
        # You can access packages and modules from different nixpkgs revs
        # at the same time. Here's an working example:
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

        # catppuccin.url = "github:catppuccin/nix";

        # Home manager
        home-manager.url = "github:nix-community/home-manager/release-24.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        spicetify-nix.url = "github:Gerg-L/spicetify-nix";

        # rust-overlay.url = "github:oxalica/rust-overlay";
    };

    outputs = inputs@{
        self,
        nixpkgs,
        nixpkgs-unstable,
        # catppuccin,
        home-manager,
        spicetify-nix,
        # rust-overlay,
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
    in with inputs; {
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
                    hardware-config = "pc";
                    use-cuda = true;
                    lite = true;
                };
                modules = [
                    # > Our main nixos configuration file <
                    # catppuccin.nixosModules.catppuccin
                    ./nixos/configuration.nix
                    spicetify-nix.nixosModules.default
                ];
            };
            laptop = nixpkgs.lib.nixosSystem {
                # pkgs = import nixpkgs { inherit system; };
                specialArgs = {
                    inherit inputs outputs system;
                    pkgs-unstable = import nixpkgs-unstable {
                        inherit system;
                        config.allowUnfree = true;
                        android_sdk.accept_license = true;
                    };
                    hardware-config = "laptop";
                    use-cuda = false;
                    lite = false;
                };
                modules = [
                    # > Our main nixos configuration file <
                    # catppuccin.nixosModules.catppuccin
                    ./nixos/configuration.nix
                    spicetify-nix.nixosModules.default
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
                    hardware-config = "fastop";
                    use-cuda = false;
                    lite = false;
                };
                modules = [
                    # > Our main nixos configuration file <
                    # catppuccin.nixosModules.catppuccin
                    ./nixos/configuration.nix
                    spicetify-nix.nixosModules.default
                ];
            };
        };

        # Standalone home-manager configuration entrypoint
        # Available through 'home-manager --flake .#your-username@your-hostname'
        # homeConfigurations = {
        #     "robert@default" = home-manager.lib.homeManagerConfiguration {
        #         pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        #         extraSpecialArgs = {inherit inputs outputs;};
        #         modules = [
        #             # > Our main home-manager configuration file <
        #             ./home-manager/home.nix
        #         ];
        #     };
        # };
    };
}
