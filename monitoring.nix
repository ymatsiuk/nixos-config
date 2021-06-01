{ pkgs, config, ... }:
let
  nodeExporter = config.services.prometheus.exporters.node;
  listenAddr = "127.0.0.1";
  nodeExporterFullDashboard = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/rfrail3/grafana-dashboards/3072e63640a8b026e2f62da5d2d53fb3dcfb0686/prometheus/node-exporter-full.json";
    sha256 = "sha256-FmkCRS9E5RSHcSZvCIH2iKH773G6DQTTJQYUwnmw+BA=";
  };
  nodeExporterBatteryDashboard = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/ymatsiuk/128e5eaba5d415e13a88f170852d8794/raw/4e432213a20d7adeb4201f0c75e1ce449cce4a0c/laptop-battery.json";
    sha256 = "sha256-SjwCr5Su+SlkJVs99TBjcFr3xv1EjMQeqqXHCneDvn0=";
  };
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
      dashboards = [
        {
          name = "Node Exporter Full";
          options.path = nodeExporterFullDashboard;
        }
        {
          name = "Laptop Battery";
          options.path = nodeExporterBatteryDashboard;
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
