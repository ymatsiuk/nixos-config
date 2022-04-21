{ config, ... }:
{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="NL"
    options iwlwifi power_save=1
    options snd_hda_intel power_save=1
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "i915" "v4l2loopback" ];
  boot.initrd.luks.devices."nixps".device = "/dev/disk/by-uuid/2f7823b9-9e81-4813-8721-55e5000f2c7f";
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [
    "quiet"
    "i915.enable_fbc=1"
    "i915.enable_guc=2"
    "i915.fastboot=1"
    "i915.mitigations=off"
    "i915.modeset=1"
    "mitigations=off"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;
  boot.tmpOnTmpfs = true;
}
