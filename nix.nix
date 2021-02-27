{
  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
}
