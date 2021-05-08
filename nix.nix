{ pkgs, lib, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
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

    (self: super: {
      xdg-desktop-portal-wlr = super.xdg-desktop-portal-wlr.overrideAttrs
        (oldAttrs: rec {
          nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];
          postInstall = ''
            wrapProgram $out/libexec/xdg-desktop-portal-wlr --prefix PATH ":" ${lib.makeBinPath [ pkgs.slurp ]}
          '';
        });
    })

  ];
}
