{ pkgs, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
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
    # (self: super: {
    #   gnome3 = super.gnome3 // {
    #     gnome-keyring = super.gnome3.gnome-keyring.overrideAttrs ( attrs: {
    #       patches = (attrs.patches or []) ++ [
    #         (super.fetchpatch {
    #           url = "https://gitlab.gnome.org/GNOME/gnome-keyring/-/commit/ebc7bc9efacc17049e54da8d96a4a29943621113.diff";
    #           sha256 = "07bx7zmdswqsa3dj37m729g35n1prhylkw7ya8a7h64i10la12cs";
    #         })
    #       ];
    #     });
    #   };
    # })
  ];
}
