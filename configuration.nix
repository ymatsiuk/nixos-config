{ config, pkgs, ... }:
{
  imports =
    [
      ./appgate.nix
      ./boot.nix
      ./docker.nix
      ./fonts.nix
      ./fprintd.nix
      ./hardware-configuration.nix
      ./home-manager.nix
      ./modules/greetd.nix
      ./neovim.nix
      ./nix.nix
      ./opengl.nix
      ./ssh.nix
      ./users.nix
    ];

  systemd.services.NetworkManager-wait-online.enable = false;
  networking = {
    hostName = "nixps";
    firewall.enable = false;
    networkmanager.enable = true;
    useDHCP = false;
  };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  sound.enable = true;

  environment = {
    homeBinInPath = true;
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/libexec" "/share/zsh" ];
    systemPackages = with pkgs; [
      coreutils
      curl
      dmidecode
      git
      htop
      openssl
      pciutils

      #doesn't work in chromium
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];
  };

  security.pki.certificates = [ (builtins.readFile /etc/ssl/certs/flexport.pem) ];
  services.fwupd.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  services.thermald.enable = true;
  services.tlp.enable = true;
  services.upower.enable = true;

  programs.light.enable = true;
  programs.seahorse.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
  };
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraPackages = with pkgs; [ ];
  };

  hardware.acpilight.enable = true;
  hardware.bluetooth = { enable = true; powerOnBoot = true; };
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
  powerManagement.powertop.enable = true;

  system.stateVersion = "21.05";
}

