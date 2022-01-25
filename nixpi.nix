{ config, pkgs, lib, ... }:
{
  boot = {
    cleanTmpDir = true;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="NL"
    '';
  };
  documentation.nixos.enable = false;
  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/libexec" "/share/zsh" ];
    variables = {
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nl_NL.UTF-8";
    };
  };
  hardware.firmware = with pkgs; [
    wireless-regdb
  ];
  networking = {
    firewall.enable = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd.settings.General.UseDefaultInterface = true;
  };
  services.openssh.enable = true;
  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];
  system.stateVersion = "22.05";
  time.timeZone = "Europe/Amsterdam";
}
