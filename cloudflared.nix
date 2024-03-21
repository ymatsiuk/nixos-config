{ pkgs, ... }:
let
  secrets = import ./secrets.nix;
in
{
  users.users = {
    cloudflared = {
      group = "cloudflared";
      isSystemUser = true;
    };
  };
  users.groups.cloudflared = { };

  systemd.services.cloudflared = {
    after = [ "network.target" "network-online.target" ];
    wants = [ "network.target" "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=${secrets.cloudflared.nixpi4.token}";
      Group = "cloudflared";
      User = "cloudflared";
      Restart = "on-failure";
    };
  };
}
