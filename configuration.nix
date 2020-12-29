{ config, pkgs, ... }:
{
  imports =
    [
      ./appgate.nix
      ./autocutsel.nix
      ./bluetooth.nix
      ./docker.nix
      ./fonts.nix
      ./hardware-configuration.nix
      ./home-manager.nix
      ./neovim.nix
      ./opengl.nix
      ./picom.nix
      ./pulseaudio.nix
      ./users.nix
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
      file
      git
      htop
      jq
      pciutils
      tree
      wget

      #HW monitor:
      acpi cpufrequtils fio i7z lm_sensors powertop smartmontools
    ];
  };

  services.fwupd.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  services.xserver = {
    enable = true;
    dpi = 220;
    videoDrivers = [ "modesetting" ];

    libinput = {
      enable = true;
      disableWhileTyping = true;
      naturalScrolling = true;
      accelSpeed = "0.5";
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.greeters.gtk = {
        theme.name = "Adwaita-black";
        cursorTheme = {
          size = 32;
        };
      };
    };

    windowManager.i3 = {
      enable = true;
    };
  };

  system.stateVersion = "20.09";
}

