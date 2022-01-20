{ config, pkgs, lib, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
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
  networking = {
    hostName = "nixpi";
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
