{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      # keep-outputs = true
      # keep-derivations = true
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
  nixpkgs.overlays = [
    (import ./overlays/default.nix)
  ];
}
