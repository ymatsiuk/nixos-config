{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez-master;
    powerOnBoot = true;
  };
}
