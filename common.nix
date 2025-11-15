{ pkgs, ... }:
let
  defaultNetworkConfig =
    {
      name,
      weight ? null,
      vlan ? null,
    }:
    {
      matchConfig.Name = name;
      networkConfig = {
        MulticastDNS = true;
        DHCP = "yes";
      }
      // pkgs.lib.optionalAttrs (vlan != null) { VLAN = vlan; };

      dhcpV4Config = {
        UseDNS = true;
      }
      // pkgs.lib.optionalAttrs (weight != null) { RouteMetric = weight; };
      dhcpV6Config.UseDNS = true;
    };
in
{
  imports = [
    ./zsh.nix
    ./upgrade-diff.nix
  ];

  documentation.nixos.enable = false;

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [
      "/libexec"
      "/share/zsh"
    ];
    variables = {
      MANPAGER = "nvim +Man!";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.ymatsiuk = import ./hm-common.nix;
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings.General = {
        Experimental = true;
        KernelExperimental = true;
      };
    };
    firmware = with pkgs; [
      linux-firmware
      sof-firmware
      wireless-regdb
    ];
  };

  networking = {
    firewall.enable = false;
    useDHCP = false;
    useNetworkd = true;
    usePredictableInterfaceNames = false;
    wireless.iwd.enable = true;
    wireless.iwd.settings.DriverQuirks.UseDefaultInterface = true;
  };

  systemd.network = {
    enable = true;
    wait-online.anyInterface = true;
    networks = {
      "wlan0" = defaultNetworkConfig {
        name = "wlan0";
        weight = 4096;
      };
      "eth0" = defaultNetworkConfig {
        vlan = [ "eth0.123" ];
        name = "eth0";
        weight = 0;
      };
      "eth0.123" = defaultNetworkConfig {
        name = "eth0.123";
        weight = 1024;
      };
    };
    netdevs = {
      "10-vlan123" = {
        netdevConfig = {
          Name = "eth0.123";
          Kind = "vlan";
        };
        vlanConfig = {
          Id = 123;
        };
      };
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "ymatsiuk" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/tailscale";
          options = [ "NOPASSWD" ];
        }
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

  # systemd.services."systemd-resolved".environment.SYSTEMD_LOG_LEVEL = "debug";
  services.resolved.enable = true;

  system.stateVersion = "25.05";

  time.timeZone = "Europe/Amsterdam";

  users = {
    mutableUsers = false;
    users = {
      ymatsiuk = {
        description = "Yurii Matsiuk";
        extraGroups = [
          "audio"
          "dialout"
          "docker"
          "video"
          "wheel"
          "ymatsiuk"
        ];
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

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
      extraOptions = ''--config-file=${
        pkgs.writeText "daemon.json" (
          builtins.toJSON {
            features = {
              buildkit = true;
            };
          }
        )
      }'';
    };
    podman.enable = true;
  };

}
