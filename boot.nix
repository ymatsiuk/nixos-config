{ pkgs, ...}:
{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.luks.devices."nixps".device = "/dev/disk/by-uuid/2f7823b9-9e81-4813-8721-55e5000f2c7f";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "msr.allow_writes=on" # required for throttled to stop erroring
    "mem_sleep_default=deep"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;
  boot.tmpOnTmpfs = true;
}
