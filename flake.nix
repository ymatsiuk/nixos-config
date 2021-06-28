{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    flexport.url = "path:/home/ymatsiuk/nixos/flexport";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    teleport-ent.url = "path:/home/ymatsiuk/nixos/teleport-ent";
  };

  outputs = inputs: {

    nixosConfigurations = {
      nixps = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          inputs.flexport.nixosModules.flexport
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
                inputs.teleport-ent.overlay
              ];
              config = { allowUnfree = true; };
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };

    overlay = final: prev: {
      kubebuilder = final.callPackage ./overlays/kubebuilder { };
      # overlay my custom firmware and kernel here
      linuxPackages = final.recurseIntoAttrs (final.linuxPackagesFor final.linux_5_13);
      linux_5_13 = final.callPackage ./overlays/kernel/linux-5.13.nix {
        kernelPatches = [
          final.kernelPatches.bridge_stp_helper
          final.kernelPatches.request_key_helper
        ];
      };
      # make pkgs from `master` available via overlay
      master = import inputs.master {
        system = final.system;
        config = final.config;
      };
    };

    packages.x86_64-linux = (builtins.head (builtins.attrValues inputs.self.nixosConfigurations)).pkgs;

    devShell.x86_64-linux = with inputs.self.packages.x86_64-linux;
      mkShell {
        buildInputs = [
          gcc
          gnumake
          nixUnstable
        ];
      };

  };
}
