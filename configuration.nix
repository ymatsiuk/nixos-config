{ config, pkgs, ... }:
{
  imports =
    [
      ./appgate.nix
      ./boot.nix
      ./fonts.nix
      ./greetd.nix
      ./hardware-configuration.nix
      ./nix.nix
      ./opengl.nix
      ./pipewire.nix
      ./ssh.nix
      ./users.nix
    ];

  networking = {
    hostName = "nixps";
    firewall.enable = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    useDHCP = false;
  };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    homeBinInPath = true;
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/libexec" "/share/zsh" ];
    variables = {
      LPASS_AGENT_TIMEOUT = "0";
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  hardware.acpilight.enable = true;
  hardware.bluetooth = { enable = true; powerOnBoot = true; };
  hardware.cpu.intel.updateMicrocode = true;
  # hardware.firmware = with pkgs; [ sof-firmware firmwareLinuxNonfree ];
  hardware.firmware = with pkgs; [
    sof-firmware
    (firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
      outputHash = "sha256-3BH22//C2ZQxQX7fUezYuoWm0qf8rAshUXfbxq+/KtU=";
      src = pkgs.fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "f8462923ed8fc874f770b8c6dfad49d39b381f14";
        sha256 = "sha256-//Gv3TRM7dAE0gVpEuPchcTOBHb9VKTKyF8HlhKqmw0=";
      };
    }))
  ];

  powerManagement.powertop.enable = true;
  programs.light.enable = true;
  programs.seahorse.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures = { base = true; gtk = true; };
    extraPackages = with pkgs; [ ];
  };

  security.rtkit.enable = true;
  security.tpm2.enable = true;

  services.fprintd = {
    enable = true;
    tod = {
      driver = pkgs.libfprint-2-tod1-goodix;
      enable = true;
    };
  };
  services.fwupd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.upower.enable = true;

  sound.enable = true;

  system.stateVersion = "21.05";

  virtualisation.docker = { enable = true; enableOnBoot = true; };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
  };
}

