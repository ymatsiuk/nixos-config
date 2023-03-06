{ pkgs, lib, ... }:
{
  imports =
    [
      ./zsh.nix
    ];

  documentation.nixos.enable = false;

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/libexec" "/share/zsh" ];
    variables = {
      LPASS_AGENT_TIMEOUT = "0";
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
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
    usePredictableInterfaceNames = false;
    wireless.iwd.enable = true;
    wireless.iwd.settings.General.UseDefaultInterface = true;
  };
  # disable wifi autostart, use `sudo systemctl start iwd.service`
  systemd.services.iwd.wantedBy = lib.mkForce [ ];

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    networks = {
      "wlan0" = {
        dhcpV4Config.RouteMetric = 4096;
        matchConfig.Name = "wlan0";
        networkConfig = {
          DNSSEC = true;
          DHCP = "yes";
          DNS = [ "1.1.1.1" "1.0.0.1" ];
        };
        dhcpV4Config.UseDNS = false;
        dhcpV6Config.UseDNS = false;
      };
      "eth0" = {
        dhcpV4Config.RouteMetric = 1024;
        matchConfig.Name = "eth0";
        networkConfig = {
          DNSSEC = true;
          DHCP = "yes";
          DNS = [ "1.1.1.1" "1.0.0.1" ];
        };
        dhcpV4Config.UseDNS = false;
        dhcpV6Config.UseDNS = false;
      };
    };
  };


  security.sudo.extraRules = [
    {
      users = [ "ymatsiuk" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/nix-collect-garbage";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

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
