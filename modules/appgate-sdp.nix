{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    programs.appgate-sdp = {
      enable = mkEnableOption
        "AppGate SDP VPN client";
    };
  };

  config = mkIf config.programs.appgate-sdp.enable {

    environment.systemPackages = [ pkgs.appgate-sdp ];
    services.dbus.packages = [ pkgs.appgate-sdp ];
    boot.kernelModules = [ "tun" ];

    systemd.services = {
      appgatedriver = {
        description = "AppGate driver service";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "always";
          Type = "forking";
          ExecStartPre = ''
            /bin/sh -c "test -e /etc/resolv.appgate && (${pkgs.e2fsprogs}/bin/chattr -i /etc/resolv.conf || :; ${pkgs.coreutils}/bin/mv /etc/resolv.appgate /etc/resolv.conf) ||:"
          '';
          ExecStart = "${pkgs.appgate-sdp}/opt/appgate/appgate-driver";
          PrivateTmp = true;
          Environment = "PATH=$PATH:${makeBinPath [ pkgs.iproute pkgs.networkmanager pkgs.dnsmasq ]}";
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectKernelTunables = true;
          CapabilityBoundingSet = [
            "~CAP_SYS_ADMIN" "~CAP_WAKE_ALARM"
            "~CAP_SYSLOG" "~CAP_SYS_TTY_CONFIG"
            "~CAP_SYS_TIME" "~CAP_SYS_RESOURCE"
            "~CAP_SYS_PTRACE" "~CAP_SYS_PACCT"
            "~CAP_SYS_CHROOT" "~CAP_SYS_BOOT"
          ];
        };
      };
      appgate-resolver = {
        description = "AppGate's own dnsmasq instance";
        serviceConfig = {
          RemainAfterExit = true;
          ExecStartPre = "${pkgs.appgate-sdp}/opt/appgate/linux/appgate-resolver.pre";
          ExecStart = "${pkgs.dnsmasq}/bin/dnsmasq -zi lo --enable-dbus=com.appgate.resolver -k -a 127.0.0.1 --clear-on-reload --resolv-file=/etc/resolv.appgate --pid-file";
          ExecStopPost = ''
            /bin/sh -c "${pkgs.e2fsprogs}/bin/chattr -i /etc/resolv.conf || :; ${pkgs.coreutils}/bin/mv /etc/resolv.appgate /etc/resolv.conf"
          '';
          Restart = "always";
          RestartSec = "1s";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          CapabilityBoundingSet = [
            "~CAP_SYS_ADMIN" "~CAP_SYSLOG"
            "~CAP_SYS_TTY_CONFIG" "~CAP_SYS_TIME"
            "~CAP_SYS_RESOURCE" "~CAP_SYS_PTRACE"
            "~CAP_SYS_NICE" "~CAP_SYS_PACCT"
            "~CAP_SYS_MODULE" "~CAP_SYS_CHROOT"
            "~CAP_SYS_BOOT"
          ];
        };
      };
      appgate-dumb-resolver = {
        description = "AppGate's dumb resolver";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.appgate-sdp}/opt/appgate/linux/appgate-dumb-resolver.pre";
          ExecStop = ''
            /bin/sh -c "${pkgs.e2fsprogs}/bin/chattr -i /etc/resolv.conf || :; ${pkgs.coreutils}/bin/mv /etc/resolv.appgate /etc/resolv.conf"
          '';
        };
      };
    };
  };
}
