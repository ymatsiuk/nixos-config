{ config, pkgs, ... }:
{
  imports =
    [
      ./appgate.nix
      ./boot.nix
      ./fonts.nix
      ./greetd.nix
      ./hardware-configuration.nix
      ./home-manager.nix
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
    };
    systemPackages = with pkgs; [
      coreutils
      curl
      dmidecode
      git
      openssl
      pciutils

      #doesn't work in chromium
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];
  };

  hardware.acpilight.enable = true;
  hardware.bluetooth = { enable = true; powerOnBoot = true; };
  hardware.cpu.intel.updateMicrocode = true;
  hardware.firmware = with pkgs; [
    sof-firmware
    (firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
      outputHash = "sha256-8DKcz+b6VXiJerPaIcn4AhVjSp01qkDmwpIxKoVzCxA=";
      src = pkgs.fetchgit {
        url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
        rev = "ecdfcf8e2ca15f5682ab94fd30ba29fb869b24a";
        sha256 = "sha256-JD7Nrb0KzOQ/fpQeI4+m5Q7Xi7pc2Lf5WzNM931UY+o=";
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

  security.pki.certificates = [ (builtins.readFile /etc/ssl/certs/flexport.pem) ];
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
  services.gnome3.gnome-keyring.enable = true;
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.upower.enable = true;

  sound.enable = true;

  system.stateVersion = "21.05";

  systemd.services.NetworkManager-wait-online.enable = false;

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

