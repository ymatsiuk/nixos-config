{ pkgs, config, ... }:
{
  system.fsPackages = [ pkgs.apfsprogs ];
  boot.extraModulePackages = [ config.boot.kernelPackages.apfs ];
  boot.initrd.kernelModules = [ "apfs" ];
}
