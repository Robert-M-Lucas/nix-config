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
  is-wsl,
  stateVersion,
  ...
}: {
  # You can import other home-manager modules here
  imports =
    [
      ./packages.nix
      ./configurations.nix
      ./dotconfig.nix
    ]
    ++ (
      if is-wsl
      then []
      else [./gnome.nix]
    );

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

  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = stateVersion;
}
