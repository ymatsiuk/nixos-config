{ pkgs, ... }:
{
  imports =
    [
      ./neovim.nix
      ./zsh.nix
    ];

  documentation.nixos.enable = false;

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/libexec" "/share/zsh" ];
    variables = {
      LPASS_AGENT_TIMEOUT = "0";
      MANPAGER = "nvim +Man!";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ymatsiuk = import ./hm-cli.nix;
  hardware.firmware = with pkgs; [ linux-firmware sof-firmware wireless-regdb ];

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
    useDHCP = false;
    # fix iwd race by disabling iface management
    wireless.iwd.settings.General.UseDefaultInterface = true;
  };

  system.stateVersion = "22.05";

  time.timeZone = "Europe/Amsterdam";

  users = {
    mutableUsers = false;
    users = {
      ymatsiuk = {
        description = "Yurii Matsiuk";
        extraGroups = [ "ymatsiuk" "wheel" "audio" "video" "networkmanager" ];
        shell = pkgs.zsh;
        home = "/home/ymatsiuk";
        isNormalUser = true;
        uid = 1000;
        hashedPassword = "$6$qKPriFgsR5Qi$LusDW9UOXt0DylMTL6K7D7N63Ol7KCZwLBd8kF5dD7W28N2jnSfWxwDZCvES1z7Sa1wCRgzkweMnyuAMo5kec.";
      };
    };
    groups = {
      ymatsiuk = {
        gid = 1000;
        members = [ "ymatsiuk" ];
      };
    };
  };

  virtualisation.podman.enable = true;
}
