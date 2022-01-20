{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    flexport.inputs.nixpkgs.follows = "nixpkgs";
    flexport.url = "git+https://github.flexport.io/ymatsiuk/flexport-overlay.git?ref=main";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, nur, home-manager, flexport, flake-utils, nixos-hardware }:
    let
      makeOpinionatedNixpkgs = system: overlays:
        import nixpkgs {
          inherit system overlays;
          config = { allowUnfree = true; };
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
            self.overlays.nixps
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

        nixpi = makeOpinionatedNixosConfig {
          system = "aarch64-linux";
          overlays = [ ];
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
            ./nixpi.nix
            ./users.nix
            ./sdimage.nix
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
        };

        # nix build ".#nixosConfigurations.nixpisdi"
        nixpisdi = self.nixosConfigurations.nixpi.config.system.build.sdImage;
      };
      overlays = {
        nixps = final: prev: {
          # TODO: move kernel to NUR
          linuxPackages = final.recurseIntoAttrs (final.linuxPackagesFor final.linux_latest);
          linux_latest = final.callPackage ./overlays/kernel.nix {
            kernelPatches = [ final.kernelPatches.bridge_stp_helper final.kernelPatches.request_key_helper ];
          };
          firefox = final.firefox-bin.override { forceWayland = true; };
          firmwareLinuxNonfreeGit = final.callPackage ./overlays/firmware.nix { };
          slackWayland = final.callPackage ./overlays/slack.nix { forceWayland = true; enablePipewire = true; };
        };
      };
    } // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = makeOpinionatedNixpkgs system [ self.overlays.nixps ];
      in
      {
        packages = {
          linux_latest = pkgs.linux_latest;
          firmwareLinuxNonfreeGit = pkgs.firmwareLinuxNonfreeGit;
        };
      }
    );
}
