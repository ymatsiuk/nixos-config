{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    flexport.inputs.nixpkgs.follows = "nixpkgs";
    flexport.url = "git+https://github.flexport.io/ymatsiuk/flexport-overlay.git?ref=main";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs: {

    nixosConfigurations = {
      nixps = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          inputs.flexport.nixosModules.ca
          inputs.flexport.nixosModules.appgate-sdp
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ymatsiuk = import ./home-manager.nix;
          }
          {
            config.nixpkgs = {
              overlays = [
                inputs.self.overlay
                inputs.flexport.overlay
              ];
              config = { allowUnfree = true; };
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };

    overlay = final: prev: {
      linuxPackages = final.recurseIntoAttrs (final.linuxPackagesFor final.linux_latest);
      linux_custom = final.callPackage ./overlays/kernel.nix { };
      chromiumos-firmware = final.callPackage ./overlays/chromiumos-firmware.nix { };
      firefox = final.firefox-beta-bin.override { forceWayland = true; };
      slack = final.callPackage ./overlays/slack.nix { forceWayland = true; enablePipewire = true; };
    };

    packages.x86_64-linux = (builtins.head (builtins.attrValues inputs.self.nixosConfigurations)).pkgs;

    devShell.x86_64-linux = with inputs.self.packages.x86_64-linux;
      mkShell {
        buildInputs = [
          nixUnstable
        ];
      };

  };
}
