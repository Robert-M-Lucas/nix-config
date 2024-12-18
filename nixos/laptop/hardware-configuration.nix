# Do not modify this file!    It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.    Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" "v4l2loopback" ];
    boot.extraModulePackages = with config.boot.kernelPackages; [ 
        v4l2loopback
        perf
    ];
    boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    security.polkit.enable = true;


    fileSystems."/" =
        { device = "/dev/disk/by-uuid/346b4f4a-76d9-4af5-a932-1a776a1e66b2";
            fsType = "ext4";
        };

    fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/D233-EFFC";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
        };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
