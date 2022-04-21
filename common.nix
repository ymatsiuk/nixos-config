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
      NIXOS_OZONE_WL = "1";
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
    useDHCP = false;
    useNetworkd = true;
    wireless.iwd.enable = true;
  };

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    networks = {
      "99-dhcp-wlan" = {
        DHCP = "yes";
        dhcpV4Config.UseDNS = false;
        dhcpV6Config.UseDNS = false;
        matchConfig.Type = "wlan";
      };
      "99-dhcp-eth" = {
        DHCP = "yes";
        dhcpV4Config.UseDNS = false;
        dhcpV6Config.UseDNS = false;
        matchConfig.Name = "eth*";
      };
    };
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    extraConfig = ''
      DNSOverTLS=yes
    '';
  };

  system.stateVersion = "22.05";

  time.timeZone = "Europe/Amsterdam";

  users = {
    mutableUsers = false;
    users = {
      ymatsiuk = {
        description = "Yurii Matsiuk";
        extraGroups = [ "audio" "docker" "video" "wheel" "ymatsiuk" ];
        shell = pkgs.zsh;
        home = "/home/ymatsiuk";
        isNormalUser = true;
        uid = 1000;
        hashedPassword = "$6$HPqs.mVB9AJtphId$RvKD12EQMt63fGcJnv3V7PIYKKg0GlenrOLWZpdAn7DOjDUDax/xTv1YO8fjVtmfpXdAHpRQoDGOeyEWoO0w41";
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
