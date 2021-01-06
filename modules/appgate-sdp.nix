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
    environment.systemPackages = [ pkgs.appgate-sdp ];
    services.dbus.packages = [ pkgs.appgate-sdp ];
    systemd = {
      packages = [ pkgs.appgate-sdp ];
      services.appgatedriver.wantedBy =  [ "multi-user.target" ];
    };
  };
}
