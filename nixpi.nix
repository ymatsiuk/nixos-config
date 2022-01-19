{ config, pkgs, ... }:

{
  imports =
    [
      ./users.nix
    ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = "nixpi";
    firewall.enable = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    # fix iwd race by disabling iface management
    wireless.iwd.settings.General.UseDefaultInterface = true;
  };

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

  services.openssh.enable = true;
  system.stateVersion = "22.05";
}
