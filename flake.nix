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
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      home-manager,
      flake-utils,
      nixpkgs-small,
      nixos-hardware,
      nixpkgs-wayland,
    }:
    let
      makeOpinionatedNixpkgs =
        system: overlays:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            # use nixos-unstable-small as the most recent kernel source
            (final: prev: {
              linuxPackages = prev.recurseIntoAttrs (prev.linuxPackagesFor final.linux_latest);
              linux_latest = nixpkgs-small.legacyPackages.${system}.linux_latest;
            })
          ] ++ overlays;
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
              nix.settings = {
                trusted-public-keys = [
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                  "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
                ];
                substituters = [
                  "https://cache.nixos.org"
                  "https://nixpkgs-wayland.cachix.org"
                ];
              };
              nixpkgs = {
                inherit pkgs;
              };
            }
          ] ++ modules;
        };
    in
    {
      nixosConfigurations = {
        nixps = makeOpinionatedNixosConfig {
          system = "x86_64-linux";
          overlays = [
            nur.overlay
            self.overlays.wrk
            nixpkgs-wayland.overlay
          ];
          modules = [
            ./nixps.nix
            { networking.hostName = "nixps"; }
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
          terraform = prev.mkTerraform {
            version = "1.2.4";
            hash = "sha256-FpRn0cFO3/CKdFDeAIu02Huez4Jpunpf6QH9KFVn2lQ=";
            vendorHash = "sha256-1RKnNF3NC0fGiU2VKz43UBGP33QrLxESVuH6IV6kYqA=";
          };
          tf_1_5_7 = prev.mkTerraform {
            version = "1.5.7";
            hash = "sha256-pIhwJfa71/gW7lw/KRFBO4Q5Z5YMcTt3r9kD25k8cqM=";
            vendorHash = "sha256-lQgWNMBf+ioNxzAV7tnTQSIS840XdI9fg9duuwoK+U4=";
          };
          rbw = prev.rbw.overrideAttrs (_: {
            src = prev.fetchFromGitHub {
              owner = "davla";
              repo = "rbw";
              rev = "fix/client-name-header";
              sha256 = "sha256-Sgs+qjKdtS5i7zF86TLSZMVKTDoeYhIgKEwjUUXw/cc=";
            };
            cargoDeps = prev.rustPlatform.importCargoLock {
              lockFile = (
                prev.fetchurl {
                  url = "https://raw.githubusercontent.com/davla/rbw/dd6b65427de3a4b38d27350d8ad7ebacb29e97ff/Cargo.lock";
                  hash = "sha256-bAELLBb0x0BOGPMLBRX/s0qxqN8XOxUW9OUa55WjeaA=";
                }
              );
              allowBuiltinFetchGit = true;
            };
          });
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
              linux_latest = pkgs.linux_latest;
              fprintd-tod = pkgs.fprintd-tod;
              libfprint-tod = pkgs.libfprint-tod;
              terraform = pkgs.terraform;
              tf_1_5_7 = pkgs.tf_1_5_7;
              rbw = pkgs.rbw;
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
              wrk = pkgs.mkShell {
                buildInputs = [
                  pkgs.python312Packages.pip
                  pkgs.python3
                  pkgs.zip
                  pkgs.tf_1_5_7
                ];
              };
            };
          }
        );
}
