# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    pkgs-unstable,
    use-cuda,
    ...
}: {
    # You can import other home-manager modules here
    imports = [
        # If you want to use modules your own flake exports (from modules/home-manager):
        # outputs.homeManagerModules.example

        # Or modules exported from other flakes (such as nix-colors):
        # inputs.nix-colors.homeManagerModules.default

        # You can also split up your configuration and import pieces of it here:
        # ./nvim.nix
        ./packages.nix
        ./configurations.nix
        ./gnome.nix
        ./dotconfig.nix
        inputs.catppuccin.homeManagerModules.catppuccin
    ];

    catppuccin.flavor = "frappe";
    catppuccin.accent = "sapphire";
    # catppuccin.enable = true;
    catppuccin.pointerCursor.enable = true;
    gtk.enable = true;
    gtk.catppuccin.enable = true;
    gtk.catppuccin.gnomeShellTheme = true;
    gtk.catppuccin.icon.enable = true;
    programs.fish.catppuccin.enable = false;
    qt.style.catppuccin.enable = true;
    
    # programs.starship = {
    #     enable = true;
    #     catppuccin.enable = true;
    # };

    nixpkgs = {
        # You can add overlays here
        overlays = [
            # Add overlays your own flake exports (from overlays and pkgs dir):
            outputs.overlays.additions
            outputs.overlays.modifications
            outputs.overlays.unstable-packages

            # You can also add overlays exported from other flakes:
            # neovim-nightly-overlay.overlays.default

            # Or define it inline, for example:
            # (final: prev: {
            #     hi = final.hello.overrideAttrs (oldAttrs: {
            #         patches = [ ./change-hello-to-hi.patch ];
            #     });
            # })
        ];
        # Configure your nixpkgs instance
        config = {
            # Disable if you don't want unfree packages
            allowUnfree = true;
            cudaSupport = use-cuda;
        };
    };

    home = {
        username = "robert";
        homeDirectory = "/home/robert";
    };

    home.sessionPath = [
        "$HOME/.npm-global/bin/"
        "$HOME/.cargo/bin"
        "$HOME/RustroverProjects/rss/target/release"
    ];

    home.file.".background-image".source = ./assets/wallpaper.JPG;

    # gtk = {
    #     enable = true;
    #     theme = {
    #         name = "Graphite-Dark";
    #         package = pkgs.graphite-gtk-theme;
    #     };
    # };    

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.05";
}
