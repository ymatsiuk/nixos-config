{ config, pkgs, lib, ... }:
{
  imports =
    [
      ./boot.nix
      ./fonts.nix
      ./greetd.nix
      ./hardware-configuration.nix
      ./opengl.nix
      ./pipewire.nix
      ./users.nix
    ];

  networking = {
    hostName = "nixps";
    firewall.enable = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    useDHCP = false;
    # fix iwd race by disabling iface management
    wireless.iwd.settings.General.UseDefaultInterface = true;
  };

  # Debug iwd
  systemd.services.iwd.serviceConfig.ExecStart = [
    ""
    "${pkgs.iwd}/libexec/iwd -d"
  ];

  time.timeZone = "Europe/Amsterdam";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nl_NL.UTF-8";
    };
  };

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/libexec" "/share/zsh" ];
    variables = {
      LPASS_AGENT_TIMEOUT = "0";
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };


  hardware.bluetooth = {
    enable = true;
    # only available in bluez>5.61
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  hardware.firmware = with pkgs; [
    firmwareLinuxNonfreeGit
    sof-firmware
    wireless-regdb
  ];

  programs.light.enable = true;
  programs.seahorse.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures = { base = true; gtk = true; };
    extraPackages = with pkgs; [ ];
  };

  security.rtkit.enable = true;
  security.tpm2.enable = true;

  services.fwupd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;

  sound.enable = true;

  system.stateVersion = "21.05";

  virtualisation.podman.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
  };
}
