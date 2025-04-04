{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-server";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  console.keyMap = "uk";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;

  programs.dconf.enable = true;

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.robert = {
    isNormalUser = true;
    description = "Robert Lucas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      (writeShellScriptBin "nix-clean" (builtins.readFile /home/robert/nix-config/home-manager/scripts/nix-clean.sh))
      (writeShellScriptBin "server-update" (builtins.readFile /home/robert/nix-config/server/server-update.sh))
      (writeShellScriptBin "doff" (builtins.readFile /home/robert/nix-config/server/doff.sh))
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.bash = {
  interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
    set fish_greeting
  '';
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-tour
      gnome-connections
      epiphany
      geary
      yelp
      seahorse
      gnome-clocks
      gnome-maps
      gnome-weather
    ]);
  environment.systemPackages = with pkgs; [
    wget
    git
    gh
    tmux
    google-chrome
    vscode
    python3
    diff-so-fancy
  ];

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ 22 ];

  system.stateVersion = "24.11";
}
