{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-small,
      nur,
      home-manager,
      flake-utils,
      nixos-hardware,
    }:
    let
      makeOpinionatedNixpkgs =
        system: overlays:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              # use nixos-unstable-small as the most recent kernel source
              linux_latest = nixpkgs-small.legacyPackages.${system}.linux_latest;
              # global override for linuxPackages to use the latest kernel
              linuxPackages = final.linuxPackagesFor final.linux_latest;
            })
          ]
          ++ overlays;
        };
      makeOpinionatedNixosConfig =
        {
          system,
          modules,
          overlays,
        }:
        let
          pkgs = makeOpinionatedNixpkgs system overlays;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./common.nix
            home-manager.nixosModules.home-manager
            {
              nix.extraOptions = "experimental-features = nix-command flakes";
              nix.registry.nixpkgs.flake = nixpkgs;
              nixpkgs = {
                inherit pkgs;
              };
            }
          ]
          ++ modules;
        };
    in
    {
      nixosConfigurations = {
        nixps = makeOpinionatedNixosConfig {
          system = "x86_64-linux";
          overlays = [
            nur.overlays.default
            self.overlays.wrk
          ];
          modules = [
            ./nixps.nix
            { networking.hostName = "nixps"; }
          ];
        };

        nixlab = makeOpinionatedNixosConfig {
          system = "x86_64-linux";
          overlays = [ ];
          modules = [
            ./nixlab.nix
            { networking.hostName = "nixlab"; }
          ];
        };

        nixpi4 = makeOpinionatedNixosConfig {
          system = "aarch64-linux";
          overlays = [ ];
          modules = [
            { networking.hostName = "nixpi4"; }
            ./nixpi4.nix
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };

        nixpi3 = makeOpinionatedNixosConfig {
          system = "aarch64-linux";
          overlays = [ ];
          modules = [
            { networking.hostName = "nixpi3"; }
            ./nixpi.nix
          ];
        };

        # nix build ".#nixosConfigurations.nixpisdi4"
        nixpisdi4 = self.nixosConfigurations.nixpi4.config.system.build.sdImage;
        # nix build ".#nixosConfigurations.nixpisdi3"
        nixpisdi3 = self.nixosConfigurations.nixpi3.config.system.build.sdImage;
      };
      overlays = {
        wrk = final: prev: {
          fprintd-tod = final.callPackage test/tod.nix { };
          libfprint-tod = final.callPackage test/libfprint-tod.nix { };
        };
      };
    }
    //
      flake-utils.lib.eachSystem
        [
          "x86_64-linux"
          "aarch64-linux"
        ]
        (
          system:
          let
            pkgs = makeOpinionatedNixpkgs system [
              self.overlays.wrk
            ];
          in
          {
            packages = {
              fprintd-tod = pkgs.fprintd-tod;
              libfprint-tod = pkgs.libfprint-tod;
            };
            devShells = {
              work = pkgs.mkShell {
                buildInputs = [
                  pkgs.python312Packages.pip
                  pkgs.python3
                  pkgs.zip
                  pkgs.terraform
                ];
              };
            };
          }
        );
}
