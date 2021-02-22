{ config, pkgs, ... }:

let
  appgate = import <appgate> {
    # Include the nixos config when importing appgate
    # But remove packageOverrides to avoid infinite recursion
    config = removeAttrs config.nixpkgs.config [ "packageOverrides" ];
  };
in
{
  disabledModules = [ "programs/appgate-sdp.nix" ];
  imports =
    [
      <appgate/nixos/modules/programs/appgate-sdp.nix>
    ];

  nixpkgs.config.packageOverrides = pkgs: {
    appgate-sdp = appgate.appgate-sdp;
  };

  programs.appgate-sdp.enable = true;
}
