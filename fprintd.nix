{
  imports = [
    ./modules/fprintd.nix
  ];

  disabledModules = [ "services/security/fprintd.nix" ];

  #merge this into configuration.nix once #117928 merged
  services.fprintd = {
    enable = true;
    tod.enable = true;
  };
}
