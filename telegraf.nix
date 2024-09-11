let
  secrets = import ./secrets.nix;
in
{
  services.telegraf = {
    enable = true;
    extraConfig = {
      inputs = {
        cpu = {
          percpu = true;
          totalcpu = true;
          collect_cpu_time = false;
          report_active = false;
        };
        disk = {
          ignore_fs = [
            "tmpfs"
            "devtmpfs"
            "devfs"
            "iso9660"
            "overlay"
            "aufs"
            "squashfs"
          ];
        };
        diskio = { };
        mem = { };
        nstat = { };
        processes = { };
        swap = { };
        system = { };
        temp = { };
      };
      outputs = {
        influxdb_v2 = {
          urls = [ secrets.telegraf.system.host ];
          token = secrets.telegraf.system.token;
          organization = secrets.telegraf.system.org;
          bucket = secrets.telegraf.system.bucket;
        };
      };
    };
  };
}
