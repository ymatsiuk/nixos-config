{ config, pkgs, ... }:

let
  appgate = import <bluetooth> {
    # Include the nixos config when importing appgate
    # But remove packageOverrides to avoid infinite recursion
    config = removeAttrs config.nixpkgs.config [ "packageOverrides" ];
  };
in
{
  disabledModules = [ "services/hardware/bluetooth.nix" ];
  imports =
    [
      <bluetooth/nixos/modules/services/hardware/bluetooth.nix>
    ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
}
