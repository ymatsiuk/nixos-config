{ config, pkgs, lib, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" ];
    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
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
  hardware.firmware = with pkgs; [
    firmwareLinuxNonfreeGit
    sof-firmware
    wireless-regdb
  ];
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nl_NL.UTF-8";
    };
  };
  networking = {
    firewall.enable = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd.settings.General.UseDefaultInterface = true;
  };
  services.openssh.enable = true;
  system.stateVersion = "22.05";
  time.timeZone = "Europe/Amsterdam";
}
