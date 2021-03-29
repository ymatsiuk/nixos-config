{
  imports = [
    ./modules/fprintd.nix
  ];

  disabledModules = [ "services/security/fprintd.nix" ];

  services.fprintd = {
    enable = true;
    tod.enable = true;
  };
}
