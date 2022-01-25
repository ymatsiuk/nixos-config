{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flexport.inputs.nixpkgs.follows = "nixpkgs";
    flexport.url = "git+https://github.flexport.io/ymatsiuk/flexport-overlay.git?ref=main";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur, home-manager, flexport, flake-utils }:
    let
      makeOpinionatedNixpkgs = system: overlays:
        import nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
      makeOpinionatedNixosConfig = { system, modules, overlays }:
        let
          pkgs = makeOpinionatedNixpkgs system overlays;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.ymatsiuk = import ./hm-cli.nix;
              nix.extraOptions = "experimental-features = nix-command flakes";
              nix.package = pkgs.nixUnstable;
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
            self.overlays.fw
            self.overlays.kernel
            self.overlays.wayland
            flexport.overlay
            nur.overlay
          ];
          modules = [
            ./nixps.nix
            { home-manager.users.ymatsiuk = import ./hm-gui.nix; }
            flexport.nixosModules.appgate-sdp
            flexport.nixosModules.ca
            flexport.nixosModules.tctl
          ];
        };

        nixpi4 = makeOpinionatedNixosConfig {
          system = "aarch64-linux";
          overlays = [
            # rpi kernel module workaround
            (final: super: {
              makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
            })
          ];
          modules = [
            ({ pkgs, ... }: { boot.kernelPackages = pkgs.linuxPackages_rpi4; })
            { networking.hostName = "nixpi4"; }
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
            ./nixpi.nix
            ./users.nix
            ./sdimage.nix
          ];
        };

        nixpi3 = makeOpinionatedNixosConfig {
          system = "aarch64-linux";
          overlays = [
            # rpi kernel module workaround
            (final: super: {
              makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
            })
          ];
          modules = [
            ({ pkgs, ... }: { boot.kernelPackages = pkgs.linuxPackages_rpi3; })
            {
              boot.loader.raspberryPi = {
                enable = true;
                version = 3;
                uboot.enable = true;
              };
              networking.hostName = "nixpi3";
            }
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
            ./nixpi.nix
            ./users.nix
            ./sdimage.nix
          ];
        };

        # nix build ".#nixosConfigurations.nixpisdi4"
        nixpisdi4 = self.nixosConfigurations.nixpi4.config.system.build.sdImage;
        # nix build ".#nixosConfigurations.nixpisdi3"
        nixpisdi3 = self.nixosConfigurations.nixpi3.config.system.build.sdImage;
      };
      overlays = {
        fw = final: prev: {
          firmwareLinuxNonfreeGit = final.callPackage ./overlays/firmware.nix { };
        };
        kernel = final: prev: {
          # TODO: move kernel to NUR
          linuxPackages = final.recurseIntoAttrs (final.linuxPackagesFor final.linux_latest);
          # linux_latest = final.callPackage ./overlays/kernel.nix {
          #   kernelPatches = [ final.kernelPatches.bridge_stp_helper final.kernelPatches.request_key_helper ];
          # };
        };
        wayland = final: prev: {
          firefox = final.firefox-bin.override { forceWayland = true; };
          slackWayland = final.callPackage ./overlays/slack.nix { forceWayland = true; enablePipewire = true; };
        };
      };
    } // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = makeOpinionatedNixpkgs system [ self.overlays.fw self.overlays.kernel ];
      in
      {
        packages = {
          linux_latest = pkgs.linux_latest;
          firmwareLinuxNonfreeGit = pkgs.firmwareLinuxNonfreeGit;
        };
      }
    );
}
