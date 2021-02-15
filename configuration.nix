{ config, pkgs, ... }:
{
  imports =
    [
      # ./appgate-testing.nix
      ./appgate.nix
      ./bluetooth.nix
      ./docker.nix
      ./fonts.nix
      ./hardware-configuration.nix
      ./home-manager.nix
      ./modules/greetd.nix
      ./neovim.nix
      ./nix.nix
      ./opengl.nix
      # ./picom.nix
      ./pulseaudio.nix
      ./ssh.nix
      ./users.nix
    ];

  systemd.services.NetworkManager-wait-online.enable = false;
  networking = {
    hostName = "xps";
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
    variables = {
      LPASS_AGENT_TIMEOUT = "0";
    };
    pathsToLink = [ "/libexec" "/share/zsh" ];
    systemPackages = with pkgs; [
      coreutils
      curl
      dmidecode
      git
      htop
      openssl
      pciutils
      wget

      #HW monitor:
      acpi cpufrequtils lm_sensors

      #doesn't work in chromium
      vulkan-loader vulkan-validation-layers vulkan-tools
    ];
  };

  security.pki.certificates = [(builtins.readFile /etc/ssl/certs/flexport.pem)];
  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.throttled.enable = true;
  services.tlp.enable = true;
  services.fprintd.enable = true;
  services.upower.enable = true;
  services.pipewire.enable = true;
  services.gnome3.gnome-keyring.enable = true;

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
     extraPackages = [];
  };

  system.stateVersion = "21.05";
}

