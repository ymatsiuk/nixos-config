{ config, ... }:
let
  nodeExporter = config.services.prometheus.exporters.node;
  listenAddr = "127.0.0.1";
in
{
  services.grafana = {
    enable = true;
    addr = listenAddr;
    port = 3000;
    provision = {
      enable = true;
      datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${listenAddr}:9090";
        }
      ];
    };
  };
  services.prometheus = {
    enable = true;
    listenAddress = listenAddr;
    port = 9090;
    scrapeConfigs = [
      {
        job_name = "localhost";
        static_configs = [{
          targets = [ "${nodeExporter.listenAddress}:${toString nodeExporter.port}" ];
        }];
      }
    ];
    exporters = {
      node = {
        enable = true;
        listenAddress = listenAddr;
        port = 9100;
        enabledCollectors = [ "systemd" "wifi" ];
      };
    };
  };
}
