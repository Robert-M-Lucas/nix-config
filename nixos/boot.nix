{
  pkgs,
  is-wsl,
  is-worktop,
  ...
}: {
  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = ["nfs"];

  boot.loader.timeout = -1;
  boot.loader.grub =
    if is-wsl
    then {}
    else {
      splashImage = null;
      enable = true;
      useOSProber = true;
      devices = ["nodev"];
      efiSupport = true;
      configurationLimit =
        if is-worktop
        then 2
        else 100;

      extraEntries = ''
        menuentry "UEFI Settings" {
            fwsetup
        }

        menuentry "Shutdown" {
            halt
        }
      '';

      extraConfig = ''
        set lang=en
        export lang
        set locale_dir=
      '';

      theme =
        # if is-worktop
        # then null
        # else
        pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.2";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
    };
}
