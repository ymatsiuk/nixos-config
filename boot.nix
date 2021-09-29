{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.luks.devices."nixps".device = "/dev/disk/by-uuid/2f7823b9-9e81-4813-8721-55e5000f2c7f";
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="NL"
    options iwlwifi power_save=1
  '';
  boot.kernelParams = [
    "quiet"
    "i915.enable_dc=4"
    "i915.enable_fbc=1"
    "i915.fastboot=1"
    "i915.enable_guc=2"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.timeout = 1;
}
