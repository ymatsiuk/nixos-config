{
  imports = [
    ./modules/appgate.nix
  ];

  disabledModules = [ "programs/appgate-sdp.nix" ];
  programs.appgate-sdp.enable = true;
}
