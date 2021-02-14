{ config, pkgs, ... }:
{
  imports =
    [
      ./appgate.nix
      # ./appgate-testing.nix
      ./autocutsel.nix
      ./bluetooth.nix
      ./docker.nix
      ./fonts.nix
      ./gnome-keyring.nix
      ./hardware-configuration.nix
      ./home-manager.nix
      ./neovim.nix
      ./opengl.nix
      ./picom.nix
      ./pulseaudio.nix
      ./security.nix
      ./ssh.nix
      ./users.nix
      ./xserver.nix
    ];

  networking = {
    hostName = "xps";
    interfaces.wlp2s0.useDHCP = true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  sound.enable = true;

  nix = {
    autoOptimiseStore = true;
    gc.automatic = true;
    optimise.automatic = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {
        enableHybridCodec = true;
      };
    };
  };

  environment = {
    homeBinInPath = true;
    shells = [ pkgs.zsh ];
    variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
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
      acpi cpufrequtils lm_sensors powertop smartmontools
    ];
  };

  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.throttled.enable = true;
  services.tlp.enable = true;

  system.stateVersion = "21.03";
}

