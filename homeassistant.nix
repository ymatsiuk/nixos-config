{ pkgs, ... }:
let
  secrets = import ./secrets.nix;
  format = pkgs.formats.yaml { };
  config = format.generate "hass-config.yaml" {
    default_config = { };
    http.server_port = 8124;
    homeassistant = {
      name = "Home";
      latitude = secrets.address.latitude;
      longitude = secrets.address.longitude;
      elevation = secrets.address.elevation;
      unit_system = "metric";
      time_zone = "Europe/Amsterdam";
    };
    recorder.db_url = "postgresql://hass@/homeassistant";
    influxdb = {
      api_version = 2;
      host = "localhost";
      port = "8086";
      max_retries = 10;
      ssl = false;
      verify_ssl = false;
      token = secrets.influxdb.token;
      organization = "home";
      bucket = "hass";
      include = {
        entity_globs = [
          "sensor.current_*"
          "sensor.electricity_failures"
          "sensor.energy_*"
          "sensor.gas_*"
          "sensor.long_electricity_failures"
          "sensor.power_*"
          "sensor.voltage_*"
        ];
      };
    };
  };
in
{

  services.influxdb2.enable = true;

  services.mosquitto = {
    enable = true;
    listeners = [{
      acl = [ "pattern readwrite #" ];
      omitPasswordAuth = true;
      settings.allow_anonymous = true;
    }];
  };

  services.postgresql = {
    enable = true;
    authentication = ''
      local homeassistant hass ident map=ha
    '';
    identMap = ''
      ha root hass
    '';
    ensureDatabases = [ "homeassistant" ];
    ensureUsers = [
      { name = "hass"; ensurePermissions = { "DATABASE homeassistant" = "ALL PRIVILEGES"; }; }
    ];
  };

  systemd.tmpfiles.rules = [
    "L+ /etc/hass/configuration.yaml - - - - ${config}"
  ];

  virtualisation.oci-containers = {
    backend = "docker";
    containers.homeassistant = {
      volumes = [
        "/var/lib/homeassistant:/config"
        "/etc/hass/configuration.yaml:/config/configuration.yaml"
        "/run/dbus:/run/dbus:ro"
        "/run/postgresql:/run/postgresql:ro"
      ];
      environment = {
        TZ = "Europe/Amsterdam";
      };
      image = "ghcr.io/home-assistant/home-assistant:2023.10.3";
      extraOptions = [
        "--device=/dev/ttyACM0"
        "--privileged"
        "--network=host"
      ];
    };
  };
}
