{ pkgs, ... }:
{
  systemd.user.services.mpris-proxy = {
    Unit.Description = "Mpris proxy";
    Unit.After = [ "network.target" "sound.target" ];
    Service.ExecStart = "${pkgs.bluez-master}/bin/mpris-proxy";
    Install.WantedBy = [ "default.target" ];
  };
}
