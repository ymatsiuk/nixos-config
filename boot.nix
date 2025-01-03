{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="NL"
    options iwlwifi power_save=1
    options snd_hda_intel power_save=1
  '';
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "vmd"
    "nvme"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.compressor = "xz";
  boot.initrd.kernelModules = [
    "i915"
    "xe"
  ];
  boot.initrd.luks.devices = {
    nixps = {
      crypttabExtraOpts = [ "tpm2-device=auto" ];
      device = "/dev/disk/by-uuid/0cebcb03-e616-4d3b-8044-cd1715c4899d";
    };
  };
  boot.initrd.systemd = {
    enable = true;
    emergencyAccess = true;
  };
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [
    "quiet"
    "i915.force_probe=!9a49"
    "xe.force_probe=9a49"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "1"; # bigger font in boot menu
  boot.loader.timeout = 1;
  boot.tmp.useTmpfs = true;
}
