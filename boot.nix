{ pkgs, ...}:
{
  boot.blacklistedKernelModules = [ "psmouse" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.initrd.luks.devices."xps".device = "/dev/disk/by-uuid/fd985262-6ad9-46ac-8bc3-c6074d60e300";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # required for throttled to stop erroring
  boot.kernelParams = [ "msr.allow_writes=on" ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.tmpOnTmpfs = true;
}
