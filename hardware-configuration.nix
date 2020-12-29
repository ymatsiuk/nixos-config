# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.initrd.availableKernelModules = [ "aesni_intel" "ahci" "cryptd" "nvme" "sd_mod" "sr_mod" "usb_storage" "usbhid" "xhci_pci" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.luks.devices."xps".device = "/dev/disk/by-uuid/fd985262-6ad9-46ac-8bc3-c6074d60e300";
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelParams = [ "i915.enable_fbc=1" "i915.enable_psr=2" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.tmpOnTmpfs = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/66407d87-26f7-47f0-8b68-b76fe31abf88";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7524-B0FE";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/693b1ff9-c7cf-405b-8107-4acf11e13780"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  powerManagement.powertop.enable = true;
  hardware.video.hidpi.enable = lib.mkDefault true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.acpilight.enable = true;
  # what's that?
  # hardware.enableAllFirmware = true;
}
