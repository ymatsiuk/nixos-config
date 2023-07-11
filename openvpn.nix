let
  secrets = import ./secrets.nix;
in
{
  networking.hosts = {
    "${secrets.nuo.git.ip}" = [ secrets.nuo.git.url ];
  };
  services.openvpn.servers.nuorder = {
    config = secrets.nuo.vpn.config;
    authUserPass = {
      username = secrets.nuo.vpn.username;
      password = secrets.nuo.vpn.password;
    };
  };
}
