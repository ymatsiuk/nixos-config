{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.luks.devices."nixps".device = "/dev/disk/by-uuid/2f7823b9-9e81-4813-8721-55e5000f2c7f";
  boot.kernelParams = [
    "quiet"
    # "i915.modeset=1"
    # "i915.enable_fbc=1"
    # "i915.enable_guc=2"
    # "i915.psr_safest_params=1"
    # "i915.mitigations=off"
    # "mitigations=off"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.timeout = 1;
  boot.tmpOnTmpfs = true;
}
