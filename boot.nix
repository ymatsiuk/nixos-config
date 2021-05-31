{ pkgs, ... }:
{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.luks.devices."nixps".device = "/dev/disk/by-uuid/2f7823b9-9e81-4813-8721-55e5000f2c7f";
  # boot.kernelPackages = pkgs.linuxPackages_5_12;
  boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_testing.override {
    argsOverride = rec {
      version = "5.13.0_drm-tip";
      modDirVersion = "5.13.0-rc4";
      extraMeta.branch = "5.13";
      ignoreConfigErrors = true;
      enableParallelBuilding = true;
      extraConfig = ''
        CONFIG_DEBUG_LIST y
        CONFIG_SOFTLOCKUP_DETECTOR y
        CONFIG_HARDLOCKUP_DETECTOR y
        CONFIG_DETECT_HUNG_TASK y
        CONFIG_WQ_WATCHDOG y
      '';
      src = pkgs.fetchgit {
        url = "git://anongit.freedesktop.org/drm-tip";
        rev = "f69143fa54fb72ca4032137764f6fa62db6c44ad";
        sha256 = "sha256-tDg5JYcyPgL9Wlqtd7n+ZqsGhsLc/gBXZX7c85NzXHU=";
      };
    };
  });
  boot.kernelParams = [
    "quiet"
    "i915.modeset=1"
    "i915.enable_fbc=1"
    "i915.enable_guc=2"
    "i915.psr_safest_params=1"
    "i915.mitigations=off"
    "mitigations=off"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.timeout = 1;
  boot.tmpOnTmpfs = true;
}
