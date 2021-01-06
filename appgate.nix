{ pkgs, config, ... }:

{
  imports = [
    overlays/appgate.nix
    ./modules/appgate-sdp.nix
  ];
  programs.appgate-sdp.enable = true;
}
