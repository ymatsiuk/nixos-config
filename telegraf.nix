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
          urls = [ "http://nixpi4:8086" ];
          token = secrets.telegraf.INFLUX_TOKEN;
          organization = "home";
          bucket = "xps";
        };
      };
    };
  };
}
