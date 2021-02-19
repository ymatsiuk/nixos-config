{ pkgs, ...}:
{
  systemd.user.services = {
    autocutsel-clipboard = {
      description = "Autocutsel sync CLIPBOARD";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 3;
        ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection CLIPBOARD";
      };
    };
    autocutsel-primary = {
      description = "Autocutsel sync PRIMARY";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        Restart = "always";
        RestartSec = 3;
        ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY";
      };
    };
  };
}
