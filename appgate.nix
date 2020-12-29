{ pkgs, config, ... }:

{
  imports = [
    overlays/appgate.nix
    ./modules/appgate-sdp.nix
  ];
  # custom shi~
  programs.appgate-sdp.enable = true;
}
