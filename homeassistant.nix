{ pkgs, lib, ... }:
let
  secrets = import ./secrets.nix;
  format = pkgs.formats.yaml { };
  scripts = format.generate "scripts_manual.yaml" [ ];
  scenes = format.generate "scenes_manual.yaml" [ ];
  automations = format.generate "automations_manual.yaml" [
    {
      id = "1702192130957";
      alias = "Office light";
      description = "";
      trigger = [
        {
          type = "motion";
          platform = "device";
          device_id = "e1b7fc52c2cac8578bdd3d86d2f1d8a3";
          entity_id = "9fc29384a8533e48bde78e10a75566ca";
          domain = "binary_sensor";
          id = "office_motion";
        }
        {
          type = "no_motion";
          platform = "device";
          device_id = "e1b7fc52c2cac8578bdd3d86d2f1d8a3";
          entity_id = "9fc29384a8533e48bde78e10a75566ca";
          domain = "binary_sensor";
          id = "office_no_motion";
        }
      ];
      condition = [
        {
          condition = "sun";
          before = "sunrise";
          after = "sunset";
        }
      ];
      action = [
        {
          choose = [
            {
              conditions = [{ condition = "trigger"; id = [ "office_motion" ]; }];
              sequence = [{ service = "light.turn_on"; target = { area_id = "office"; }; data = { brightness_pct = 50; }; }];
            }
            {
              conditions = [{ condition = "trigger"; id = [ "office_no_motion" ]; }];
              sequence = [{ delay = { hours = 0; minutes = 2; seconds = 0; milliseconds = 0; }; } { service = "light.turn_off"; target = { area_id = "office"; }; data = { }; }];
            }
          ];
        }
      ];
      mode = "single";
    }
    {
      id = "1702295114892";
      alias = "Smart washer/dryer";
      description = "";
      trigger = [
        {
          type = "power";
          platform = "device";
          device_id = "84683e13b344f125337275de40cbd019";
          entity_id = "1675fcb4fde3f00ca03cbc62c268fe37";
          domain = "sensor";
          below = 5;
          for = { hours = 0; minutes = 5; seconds = 0; };
        }
      ];
      condition = [ ];
      action = [
        {
          service = "notify.mobile_app_pixel_8";
          data = {
            message = "cycle has finished";
            data = { ttl = 0; priority = "high"; };
          };
        }
      ];
      mode = "single";
    }
    {
      id = "1702981478448";
      alias = "Doorbell";
      description = "";
      trigger = [
        {
          type = "turned_on";
          platform = "device";
          device_id = "6ec43bd1e46a027cceea113df0b4ae4a";
          entity_id = "c675ef6e1b21cec358f651083e6e6f30";
          domain = "binary_sensor";
        }
      ];
      condition = [ ];
      action = [
        {
          service = "notify.mobile_app_pixel_8";
          data = {
            title = "Doorbell rings";
            data = { ttl = 0; priority = "high"; image = "/api/camera_proxy/camera.reolink_video_doorbell_sub"; actions = [{ action = "URI"; title = "Open HA"; uri = "/lovelace/0"; } { action = "URI"; title = "Open Reolink"; uri = "app://com.mcu.reolink"; }]; };
            message = "Someone's at the door";
          };
        }
      ];
      mode = "single";
    }
    {
      id = "1705223239528";
      alias = "Plant lights";
      description = "";
      trigger = [
        {
          platform = "time";
          at = "09:00:00";
          id = "Morning";
        }
        {
          platform = "time";
          at = "19:00:00";
          id = "Evening";
        }
      ];
      condition = [ ];
      action = [
        {
          choose = [
            { conditions = [{ condition = "trigger"; id = [ "Morning" ]; }]; sequence = [{ service = "light.turn_on"; target = { device_id = "6ef89c16b98084bfc4344652a0baf4e0"; }; data = { }; }]; }
            { conditions = [{ condition = "trigger"; id = [ "Evening" ]; }]; sequence = [{ service = "light.turn_off"; target = { device_id = "6ef89c16b98084bfc4344652a0baf4e0"; }; data = { }; }]; }
          ];
        }
      ];
      mode = "single";
    }
  ];
  config = format.generate "configuration.yaml" {
    "automation manual" = "!include automations_manual.yaml";
    "automation ui" = "!include automations.yaml";
    "scene manual" = "!include scenes_manual.yaml";
    "scene ui" = "!include scenes.yaml";
    "script manual" = "!include scripts_manual.yaml";
    "script ui" = "!include scripts.yaml";
    default_config = { };
    http.server_port = 8124;
    frontend.themes = "themes";
    homeassistant = {
      name = "Home";
      latitude = secrets.address.latitude;
      longitude = secrets.address.longitude;
      elevation = secrets.address.elevation;
      unit_system = "metric";
      time_zone = "Europe/Amsterdam";
      customize = {
        "cover.living_room_awning" = { device_class = "awning"; icon = "mdi:awning-outline"; };
        "cover.living_room_shutter_door" = { device_class = "shutter"; icon = "mdi:window-shutter"; };
        "cover.living_room_shutter_window" = { device_class = "shutter"; icon = "mdi:window-shutter"; };
        "light.ikea_of_sweden_stoftmoln_ceiling_wall_lamp_ww24_light" = { icon = "mdi:ceiling-light"; };
        "light.ikea_of_sweden_tradfri_driver_10w_light" = { friendly_name = "Table top light"; icon = "mdi:led-strip"; };
        "switch.kitchen_floor_heating" = { icon = "mdi:heating-coil"; };
        "switch.living_room_floor_heating" = { icon = "mdi:heating-coil"; };
      };
    };
    recorder.db_url = "postgresql://hass@/homeassistant";
    panel_iframe = {
      grafana = { title = "Grafana"; url = "http://nixpi4:3000"; icon = "mdi:chart-timeline"; };
      esphome = { title = "ESPHome"; url = "http://nixpi4:6052"; icon = "mdi:chip"; };
    };
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
          "sensor.*_power"
          "sensor.*_energy"
        ];
      };
    };
    zha.zigpy_config.ota.ikea_provider = true;
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

  # quick workaround for postgresql 15 permissions change
  systemd.services.postgresql.postStart = lib.mkAfter ''
    $PSQL homeassistant -tAc 'GRANT ALL ON SCHEMA public TO hass'
  '';

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      homeassistant = {
        volumes = [
          "/var/lib/homeassistant:/config"
          "${configuration}:/config/configuration.yaml"
          "${automations}:/config/automations_manual.yaml"
          "${scenes}:/config/scenes_manual.yaml"
          "${scripts}:/config/scripts_manual.yaml"
          "/run/dbus:/run/dbus:ro"
          "/run/postgresql:/run/postgresql:ro"
        ];
        environment = {
          TZ = "Europe/Amsterdam";
        };
        image = "ghcr.io/home-assistant/home-assistant:2023.12.1";
        extraOptions = [
          "--device=/dev/ttyACM0"
          "--privileged"
          "--network=host"
        ];
      };
      esphome = {
        volumes = [
          "/var/lib/homeassistant/esphome:/config"
        ];
        image = "ghcr.io/esphome/esphome:2023.9.3";
        environment = {
          ESPHOME_DASHBOARD_USE_PING = "true";
        };
        ports = [
          "6052:6052"
        ];
        extraOptions = [
          "--init"
        ];
      };
    };
  };
}
