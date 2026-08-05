{
  pkgs,
  lib,
  is-wsl,
  is-worktop,
  ...
}: {
  # Enable the X11 windowing system.
  services.xserver.enable = !is-wsl;
  services.xserver.excludePackages = [pkgs.xterm];

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = !is-wsl;
  services.desktopManager.gnome.enable = !is-wsl;

  # === KDE SPECIALISATION ===
  specialisation = lib.optionalAttrs (!is-wsl && !is-worktop) {
    kde.configuration = {
      system.nixos.tags = ["kde"];

      services.displayManager.gdm.enable = lib.mkForce false;
      services.desktopManager.gnome.enable = lib.mkForce false;

      services.gnome.gnome-keyring.enable = true;
      security.pam.services.login.enableGnomeKeyring = true;
      security.pam.services.sddm.enableGnomeKeyring = true;

      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      services.desktopManager.plasma6.enable = true;

      environment.sessionVariables = {
        QT_QPA_PLATFORMTHEME = lib.mkForce null;
        DCONF_PROFILE = lib.mkForce "kde";
      };
    };
  };

  # Configure keymap in X11
  services.xserver.xkb =
    if is-wsl
    then {}
    else {
      layout = "gb";
      variant = "";
    };

  # Configure console keymap
  console.keyMap = "uk";

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # i18n.inputMethod.enabled = "ibus"; # Enables Super + . emoji picker

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

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
  ];
}
