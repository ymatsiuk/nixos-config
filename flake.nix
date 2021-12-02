{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    flexport.inputs.nixpkgs.follows = "nixpkgs";
    flexport.url = "git+https://github.flexport.io/ymatsiuk/flexport-overlay.git?ref=main";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur, home-manager, flexport }: {

    nixosConfigurations = {
      nixps = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          flexport.nixosModules.ca
          flexport.nixosModules.appgate-sdp
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ymatsiuk = import ./home-manager.nix;
          }
          {
            config.nixpkgs = {
              overlays = [
                nur.overlay
                self.overlay
                flexport.overlay
              ];
              config = { allowUnfree = true; };
            };
          }
        ];
      };
    };

    overlay = final: prev: {
      linuxPackages = final.recurseIntoAttrs (final.linuxPackagesFor final.linux_latest);
      linux_latest = final.callPackage ./overlays/kernel.nix {
        kernelPatches = [ final.kernelPatches.bridge_stp_helper final.kernelPatches.request_key_helper ];
      };
      firefox = final.firefox-bin.override { forceWayland = true; };
      firmwareLinuxNonfreeGit = final.callPackage ./overlays/firmware.nix { };
      slackWayland = final.callPackage ./overlays/slack.nix { forceWayland = true; enablePipewire = true; };
    };

    packages.x86_64-linux = (builtins.head (builtins.attrValues self.nixosConfigurations)).pkgs;

    devShell.x86_64-linux = with self.packages.x86_64-linux;
      mkShell {
        buildInputs = [
          nixUnstable
        ];
      };

  };
}
