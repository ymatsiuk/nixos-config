{ pkgs, ... }:
let
  secrets = import ./secrets.nix;
  format = pkgs.formats.yaml { };
  scripts = format.generate "scripts.yaml" [ ];
  scenes = format.generate "scenes.yaml" [ ];
  automations = format.generate "automations.yaml" [{
    id = "1697893095905";
    alias = "Notify doorbell";
    description = "";
    trigger = [{
      platform = "state";
      entity_id = [ "binary_sensor.doorbell" ];
      from = "off";
      to = "on";
    }];
    condition = [ ];
    action = [{
      service = "notify.mobile_app_pixel_5";
      data = {
        title = "Deurbel gaat";
        message = "Er belt iemand aan";
      };
    }];
  }];
  config = format.generate "configuration.yaml" {
    automation = "!include automations.yaml";
    script = "!include scripts.yaml";
    scene = "!include scenes.yaml";
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
  # hack to fix yaml functions
  configuration = pkgs.runCommand "configuration.yaml" { preferLocalBuild = true; } ''
    cp ${config} $out
    sed -i -e "s/'\!\([a-z_]\+\) \(.*\)'/\!\1 \2/;s/^\!\!/\!/;" $out
  '';
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

  virtualisation.oci-containers = {
    backend = "docker";
    containers.homeassistant = {
      volumes = [
        "/var/lib/homeassistant:/config"
        "${configuration}:/config/configuration.yaml"
        "${automations}:/config/automations.yaml"
        "${scenes}:/config/scenes.yaml"
        "${scripts}:/config/scripts.yaml"
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
