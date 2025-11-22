# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-jb,
  use-cuda,
  is-pc,
  is-worktop,
  ...
}: let
  # Define Neuwaita icon theme package inline
  neuwaita-icon-theme = pkgs.stdenv.mkDerivation {
    pname = "neuwaita-icon-theme";
    version = "latest";

    src = pkgs.fetchFromGitHub {
      owner = "RusticBard";
      repo = "Neuwaita";
      rev = "1130e2ef16baf6b40749c9733c2de093d7bf2d30";
      sha256 = "sha256-WYDIa5/hv6ksUk6nNzQD7VrOVp1TuMHSEbO0Gt86AwQ=";
    };

    installPhase = ''
      mkdir -p $out/share/icons/Neuwaita
      cp -r * $out/share/icons/Neuwaita
    '';

    meta = with pkgs.lib; {
      description = "Neuwaita GNOME icon theme (Adwaita variant)";
      homepage = "https://github.com/RusticBard/Neuwaita";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };
in {
  # You can import other home-manager modules here
  imports = [
    ./packages.nix
    ./configurations.nix
    ./gnome.nix
    ./dotconfig.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
    config = {
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
    "$HOME/.cache/npm/global/bin"
    "$HOME/.cargo/bin"
    "$HOME/RustroverProjects/rss/target/release"
  ];

  home.file.".background-image".source = ./assets/wallpaper-tatry.JPG;

  # Enable GTK and apply Neuwaita icons
  gtk = {
    enable = true;
    iconTheme = {
      package = neuwaita-icon-theme;
      name = "Neuwaita";
    };
  };

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
