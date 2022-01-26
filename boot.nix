{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="NL"
    options iwlwifi power_save=1
    options snd_hda_intel power_save=1
  '';
  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "i915" ];
  boot.initrd.luks.devices."nixps".device = "/dev/disk/by-uuid/2f7823b9-9e81-4813-8721-55e5000f2c7f";
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "quiet" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;
  boot.tmpOnTmpfs = true;
}
