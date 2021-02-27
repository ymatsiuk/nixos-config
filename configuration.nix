{ config, pkgs, ... }:
{
  imports =
    [
      ./appgate.nix
      # ./appgate-testing.nix
      ./autocutsel.nix
      ./boot.nix
      ./bluetooth.nix
      ./docker.nix
      ./fonts.nix
      ./gnome-keyring.nix
      ./hardware-configuration.nix
      ./home-manager.nix
      ./neovim.nix
      ./intel.nix
      ./nix.nix
      ./picom.nix
      ./pulseaudio.nix
      ./ssh.nix
      ./users.nix
      ./xserver.nix
    ];

  # faster boot
  systemd.services.NetworkManager-wait-online.enable = false;
  networking = {
    hostName = "xps";
    firewall.enable = false;
    # interfaces.wlp2s0.useDHCP = true;
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
      GDK_SCALE = "2";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
      LPASS_AGENT_TIMEOUT = "0";
    };
    pathsToLink = [ "/libexec" "/share/zsh" ];
    systemPackages = with pkgs; [
      acpi
      coreutils
      cpufrequtils
      curl
      dmidecode
      git
      lm_sensors
      openssl
      pciutils
    ];
  };

  security.pki.certificates = [(builtins.readFile /etc/ssl/certs/flexport.pem)];
  services.fwupd.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "ondemand";
      TLP_DEBUG = "arg bat disk lock nm path pm ps rf run sysfs udev usb";
    };
  };
  hardware.cpu.intel.updateMicrocode = true;
  hardware.acpilight.enable = true;

  system.stateVersion = "21.05";
}

