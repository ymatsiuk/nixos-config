{ pkgs, modulesPath, lib, ... }:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./sdimage.nix
  ];

  boot = {
    initrd.availableKernelModules = lib.mkForce [ ];
    cleanTmpDir = true;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="NL"
    '';
  };

  hardware.enableRedistributableFirmware = lib.mkForce true;
  hardware.bluetooth = { enable = true; settings.General.Experimental = true; };

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  services.openssh.enable = true;

  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "hass" ];
    ensureUsers = [{
      name = "hass";
      ensurePermissions = {
        "DATABASE hass" = "ALL PRIVILEGES";
      };
    }];
  };

  services.home-assistant = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      psycopg2
    ];
    extraComponents = [
      "backup"
      "bluetooth"
      "bluetooth_le_tracker"
      "deconz"
      "esphome"
      "met"
      "radio_browser"
      "rpi_power"
      "zha"
    ];
    config = {
      default_config = { };
      esphome = { };
      deconz = { };
      bluetooth = { };
      recorder.db_url = "postgresql://@/hass";
    };
  };
}
