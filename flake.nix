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
          inherit system;
          config.allowUnfree = true;
          overlays = [
            self.overlays.kernel
          ] ++ overlays;
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
              system.stateVersion = "22.05";
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
        kernel = final: prev: {
          linuxPackages = final.recurseIntoAttrs (final.linuxPackagesFor final.linux_latest);
        };
      };
    };
}
