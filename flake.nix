{
  description = "ymatsiuk NixOS configuration";

  inputs = {
    awsvpnclient.url = "github:ymatsiuk/awsvpnclient/main";
    awsvpnclient.inputs.nixpkgs.follows = "nixpkgs";
    awsvpnclient.inputs.flake-utils.follows = "flake-utils";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nur.url = "github:nix-community/NUR";
    idasen-cli.url = "github:typetetris/idasen-cli";
    moz.url = "github:colemickens/flake-firefox-nightly";
  };

  outputs = { self, awsvpnclient, nixpkgs, nur, home-manager, nixpkgs-wayland, flake-utils, nixpkgs-master, nixpkgs-small, idasen-cli, moz }:
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
              awsvpnclient = awsvpnclient.packages.${system}.awsvpnclient;
              firefox = moz.packages.${system}.firefox-nightly-bin;
              idasen-cli = idasen-cli.packages.${system}.idasen-cli;
              master = import nixpkgs-master { system = final.system; config = final.config; };
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
            nixpkgs-wayland.overlay
            nur.overlay
            self.overlays.firmware
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
        firmware = final: prev: {
          alacritty = prev.alacritty.overrideAttrs (oldAttrs: rec {
            version = "master";
            src = prev.fetchFromGitHub {
              owner = "alacritty";
              repo = oldAttrs.pname;
              rev = "6143b3f4eb352ff4ab36149ce5ba8c6ab04e415a";
              hash = "sha256-+rc0etVL0WGfvQijumvLJOYn1aRooqv5ZPJpz14KJXg=";
            };

            cargoDeps = oldAttrs.cargoDeps.overrideAttrs (_: {
              inherit src;
              outputHash = "sha256-ZIb70LhLcPp5rKl/Asbe+pYw1FLaObtxL/6N6fyDqm0=";
            });

            postInstall = ''
              install -D extra/linux/Alacritty.desktop -t $out/share/applications/
              install -D extra/linux/org.alacritty.Alacritty.appdata.xml -t $out/share/appdata/
              install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
              $STRIP -S $out/bin/alacritty
              patchelf --add-rpath "${prev.lib.makeLibraryPath oldAttrs.buildInputs}" $out/bin/alacritty
              installShellCompletion --zsh extra/completions/_alacritty
              install -dm 755 "$terminfo/share/terminfo/a/"
              tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
              mkdir -p $out/nix-support
              echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
            '';

          });
          # linux-firmware = prev.linux-firmware.overrideAttrs (oldAttrs: rec {
          #   version = "20220509";
          #   src = prev.fetchzip {
          #     url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${version}.tar.gz";
          #     sha256 = "sha256-pNuKA4XigrHU9qC5Ch6HLs3/tcv0zIkAzow9VOIVKdQ=";
          #   };
          #   outputHash = "sha256-pXzWAu7ch4dHXvKzfrK826vtNqovCqL7pd+TIVbWnJQ=";
          # });
        };
      };
    } // flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let
        pkgs = makeOpinionatedNixpkgs system [ self.overlays.firmware ];
      in
      {
        packages = {
          linux-firmware = pkgs.linux-firmware;
          linux_latest = pkgs.linux_latest;
          awscli2 = pkgs.master.awscli2;
        };
      }
    );
}
