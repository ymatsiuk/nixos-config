{ pkgs, ... }:
{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.luks.devices."nixps".device = "/dev/disk/by-uuid/2f7823b9-9e81-4813-8721-55e5000f2c7f";
  boot.kernelPackages = pkgs.linuxPackages_5_12;
  boot.kernelParams = [
    "quiet"
    # "mem_sleep_default=deep"
    # "drm.debug=0x1e"
    # "log_buf_len=1M"
    # "intel_iommu=off"
    # "iommu=off"
    "i915.mitigations=off"
    "mitigations=off"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.timeout = 1;
  boot.tmpOnTmpfs = true;
}
