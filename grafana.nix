{ lib, ... }:
let
  secrets = import ./secrets.nix;
  adminPasswordPath = "/etc/secrets/grafana/gf_admin_password";
  influxDBTokenPath = "/etc/secrets/grafana/gf_influxdb_token";
in
{

  systemd.tmpfiles.rules = [
    "f+ ${adminPasswordPath} 0600 grafana grafana - ${secrets.grafana.admin_password}"
    "f+ ${influxDBTokenPath} 0600 grafana grafana - ${secrets.influxdb.token}"
  ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "grafana" ];
    ensureUsers = [
      { name = "grafana"; ensurePermissions = { "DATABASE grafana" = "ALL PRIVILEGES"; }; }
    ];
  };

  # quick workaround for postgresql 15 permissions change
  systemd.services.postgresql.postStart = lib.mkAfter ''
    $PSQL grafana -tAc 'GRANT ALL ON SCHEMA public TO grafana'
  '';

  services.grafana = {
    enable = true;
    settings = {
      server.http_addr = "0.0.0.0";
      database = {
        type = "postgres";
        host = "/run/postgresql";
        user = "grafana";
        name = "grafana";
      };
      security = {
        admin_user = "ymatsiuk";
        admin_password = "$__file{${adminPasswordPath}}";
        allow_embedding = true; # for home-assistant
      };
      analytics.reporting_enabled = false;
      "auth.anonymous".enabled = true;
    };
    provision = {
      enable = true;
      dashboards.settings = {
        apiVersion = 1;
        providers = [{
          name = "default";
          options.path = ./grafana;
        }];
      };
      datasources.settings = {
        apiVersion = 1;
        datasources = [{
          name = "InfluxDB";
          type = "influxdb";
          uid = "influxdb2";
          access = "proxy";
          url = "http://localhost:8086";
          secureJsonData = {
            token = "$__file{${influxDBTokenPath}}";
          };
          jsonData = {
            version = "Flux";
            organization = "home";
            defaultBucket = "hass";
            tlsSkipVerify = true;
          };
        }];
      };
    };
  };
}
