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
    boot.kernelModules = [ "tun" ];
    environment.systemPackages = [ pkgs.master.appgate-sdp ];
    services.dbus.packages = [ pkgs.master.appgate-sdp ];
    systemd = {
      packages = [ pkgs.master.appgate-sdp ];
      # https://github.com/NixOS/nixpkgs/issues/81138
      services.appgatedriver.wantedBy = [ "multi-user.target" ];
      services.appgate-dumb-resolver.path = [ pkgs.e2fsprogs ];
      services.appgate-resolver.path = [ pkgs.procps pkgs.e2fsprogs ];
      services.appgatedriver.path = [ pkgs.e2fsprogs ];
    };
  };
}

