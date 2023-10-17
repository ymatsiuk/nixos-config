let
  secrets = import ./secrets.nix;
in
{
  services.telegraf = {
    enable = true;
    extraConfig = {
      inputs = {
        system = { };
      };
      outputs = {
        influxdb_v2 = {
          urls = [ "http://nixpi4:8086" ];
          token = secrets.telegraf.system.token;
          organization = secrets.telegraf.system.org;
          bucket = secrets.telegraf.system.bucket;
        };
      };
    };
  };
}
