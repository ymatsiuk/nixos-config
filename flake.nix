{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      home-manager,
      flake-utils,
      nixos-hardware,
    }:
    let
      makeOpinionatedNixpkgs =
        system: overlays:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
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
          ] ++ modules;
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
          obs-studio-plugins = prev.obs-studio-plugins // {
            droidcam-obs = prev.obs-studio-plugins.droidcam-obs.overrideAttrs (o: rec {
              version = "2.3.4";
              src = prev.fetchFromGitHub {
                owner = "dev47apps";
                repo = "droidcam-obs-plugin";
                tag = version;
                sha256 = "sha256-KWMLhddK561xA+EjvoG4tXRW4xoLil31JcTTfppblmA=";
              };
              postPatch = "";

              nativeBuildInputs = [
                prev.pkg-config
              ];

              makeFlags = [
                "ALLOW_STATIC=no"
                "JPEG_DIR=${prev.lib.getDev prev.libjpeg}"
                "JPEG_LIB=${prev.lib.getLib prev.libjpeg}/lib"
                "IMOBILEDEV_DIR=${prev.lib.getLib prev.libimobiledevice}"
                "LIBOBS_INCLUDES=${prev.obs-studio}/include/obs"
                "FFMPEG_INCLUDES=${prev.lib.getLib prev.ffmpeg}"
                "LIBUSBMUXD=libusbmuxd-2.0"
                "LIBIMOBILEDEV=libimobiledevice-1.0"
              ];
            });
          };
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
