{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-sandbox-paths = /var/cache/ccache
    '';
    autoOptimiseStore = true;
  };
}
