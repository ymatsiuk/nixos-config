{
  imports = [
    ./modules/fprintd.nix
  ];

  disabledModules = [ "services/security/fprintd.nix" ];
}
