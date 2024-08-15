# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
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
  ];

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
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false; # enables user extensions
        enabled-extensions = [
          # Put UUIDs of extensions that you want to enable here.
          # If the extension you want to enable is packaged in nixpkgs,
          # you can easily get its UUID by accessing its extensionUuid
          # field (look at the following example).
          pkgs.gnomeExtensions.hide-top-bar.extensionUuid
          pkgs.gnomeExtensions.ddterm.extensionUuid
          pkgs.gnomeExtensions.caffeine.extensionUuid
          # pkgs.gnomeExtensions.custom-accent-colors.extensionUuid
          # Alternatively, you can manually pass UUID as a string.  
          # "blur-my-shell@aunetx"
          # ...
        ];
      };

      # Configure individual extensions
      # dconf dump /
      "com/github/amezin/ddterm" = {
        ddterm-toggle-hotkey= ["<Primary>grave"];
        hide-animation="disable";
        shortcut-win-new-tab=["<Primary>t"];
        show-animation="disable";
        tab-policy="automatic";
        window-maximize=false;
        show-scrollbar=false;
        window-size=0.40553435114503816;
      };
      "org/gnome/shell/extensions/hidetopbar" = {
        enable-active-window=false;
        enable-intellihide=false;
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme;
    };
  };

  home = {
    username = "robert";
    homeDirectory = "/home/robert";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
