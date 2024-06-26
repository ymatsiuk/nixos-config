{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    awsvpnclient.url = "github:ymatsiuk/awsvpnclient/ymatsiuk/addoverlay";
    awsvpnclient.inputs.nixpkgs.follows = "nixpkgs";
    awsvpnclient.inputs.flake-utils.follows = "flake-utils";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, awsvpnclient, nixpkgs, nur, home-manager, flake-utils, nixpkgs-small, nixos-hardware }:
    let
      makeOpinionatedNixpkgs = system: overlays:
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
      makeOpinionatedNixosConfig = { system, modules, overlays }:
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
              nix.package = pkgs.nixVersions.nix_2_19;
              nix.registry.nixpkgs.flake = nixpkgs;
              nixpkgs = { inherit pkgs; };
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
            awsvpnclient.overlays.vpn
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
          vault = prev.vault-bin;
          terragrunt = prev.terragrunt.override {
            buildGoModule = args: final.buildGoModule (args // rec {
              pname = "terragrunt";
              version = "0.52.3";
              src = prev.fetchFromGitHub {
                owner = "gruntwork-io";
                repo = pname;
                rev = "refs/tags/v${version}";
                hash = "sha256-o/4L7TBdFFHuPOKAO/wP0IBixQtZHGr1GSNlsEpq710=";
              };
              vendorHash = "sha256-RmzSKt5qt9Qb4GDrfs4dJEhGQW/jFbXPn+AOLzEyo6c=";
              doCheck = false;
              ldflags = [
                "-s"
                "-w"
                "-X github.com/gruntwork-io/go-commons/version.Version=v${version}"
              ];
              doInstallCheck = true;
              installCheckPhase = ''
                runHook preInstallCheck
                $out/bin/terragrunt --help
                $out/bin/terragrunt --version | grep "v${version}"
                runHook postInstallCheck
              '';
            });
          };
          terraform = prev.mkTerraform {
            version = "1.5.7";
            hash = "sha256-pIhwJfa71/gW7lw/KRFBO4Q5Z5YMcTt3r9kD25k8cqM=";
            vendorHash = "sha256-lQgWNMBf+ioNxzAV7tnTQSIS840XdI9fg9duuwoK+U4=";
          };
        };
      };
    } // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = makeOpinionatedNixpkgs system [
          self.overlays.wrk
          awsvpnclient.overlays.vpn
        ];
      in
      {
        packages = {
          linux_latest = pkgs.linux_latest;
        };
        devShells = {
          work = pkgs.mkShell {
            buildInputs = [
              pkgs.awsvpnclient
            ];
          };
        };
      }
    );
}
