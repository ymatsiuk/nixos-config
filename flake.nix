{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flexport.inputs.nixpkgs.follows = "nixpkgs";
    flexport.url = "git+https://github.flexport.io/ymatsiuk/flexport-overlay.git?ref=main";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur, home-manager, flexport, nixpkgs-wayland, flake-utils }:
    let
      makeOpinionatedNixpkgs = system: overlays:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            self.overlays.common
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
              nix.package = pkgs.nixUnstable;
              nix.registry.nixpkgs.flake = nixpkgs;
              nix.settings.trusted-public-keys = [
                "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
              ];
              nix.settings.substituters = [
                "https://nixpkgs-wayland.cachix.org/"
              ];
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
            flexport.overlay
            nixpkgs-wayland.overlay
            nur.overlay
            self.overlays.wayland
          ];
          modules = [
            ./nixps.nix
            { networking.hostName = "nixps"; }
            flexport.nixosModules.appgate-sdp
            flexport.nixosModules.ca
            flexport.nixosModules.tctl
          ];
        };

        nixpi4 = makeOpinionatedNixosConfig {
          system = "aarch64-linux";
          overlays = [ ];
          modules = [
            { networking.hostName = "nixpi4"; }
            ./nixpi.nix
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
        common = final: prev: {
          linuxPackages = final.recurseIntoAttrs (final.linuxPackagesFor final.linux_latest);
        };
        wayland = final: prev: {
          firefox = prev.firefox-bin.override { forceWayland = true; };
          swaylock = prev.swaylock.override {
            pam = prev.pam.overrideAttrs (_: {
              patches = [
                (prev.fetchpatch {
                  name = "suid-wrapper-path.patch";
                  url = "https://raw.githubusercontent.com/vcunat/nixpkgs/ffdadd3ef9167657657d60daf3fe0f1b3176402d/pkgs/os-specific/linux/pam/suid-wrapper-path.patch";
                  sha256 = "sha256-Qn26iHqY9DQrVL3myRjUeL1PYPirJWY7R/RYYukW2Ds=";
                })
              ];
            });
          };
        };
      };
    } // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = makeOpinionatedNixpkgs system [
          self.overlays.wayland
        ];
      in
      {
        packages = {
          swaylock = pkgs.swaylock;
        };
      }
    );
}
