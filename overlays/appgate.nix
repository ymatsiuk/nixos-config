{pkgs, ...}:
{
  nixpkgs.overlays = [
    (self: super: {
      appgate-sdp = self.callPackage ./new.nix{ };
    })
  ];
}
