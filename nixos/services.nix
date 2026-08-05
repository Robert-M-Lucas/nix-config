{
  pkgs,
  lib,
  is-wsl,
  ...
}: {
  # Network services settings in networking.nix, including tailscale and openssh
  # DE services in de.nix

  systemd.services."systemd-backlight@leds:dell::kbd_backlight" = {
    wantedBy = lib.mkForce [];
    after = lib.mkForce [];
  };
  systemd.services.systemd-backlight = {
    wantedBy = lib.mkForce [];
    after = lib.mkForce [];
  };

  # Enable CUPS to print documents.
  services.printing.enable = !is-wsl;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = !is-wsl;

  services.fprintd.enable = !is-wsl;

  services.ananicy = {
    enable = !is-wsl;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp;
  };

  # services.howdy = {
  #   enable = is-worktop;

  #   settings.video.device_path = if is-worktop then "/dev/video2" else "/dev/video0";
  #   settings.snapshots.save_failed = true;

  #   control = "sufficient";
  # };

  # security.pam.services = {
  #   polkit-1.howdy.enable = false;
  # };
}
