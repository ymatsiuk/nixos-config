{ pkgs, ... }:
let
  secrets = import ./secrets.nix;
  format = pkgs.formats.yaml { };
  scripts = format.generate "scripts_manual.yaml" [ ];
  scenes = format.generate "scenes_manual.yaml" [ ];
  automations = format.generate "automations_manual.yaml" [
    {
      id = "1702981478448";
      alias = "Doorbell notify";
      description = "";
      trigger = [
        { type = "turned_on"; platform = "device"; device_id = "6ec43bd1e46a027cceea113df0b4ae4a"; entity_id = "657e87321790b350d32c1b2208eba789"; domain = "binary_sensor"; }
      ];
      condition = [ ];
      action = [
        {
          service = "camera.snapshot";
          data = { filename = "/media/front_door.jpg"; };
          target = { entity_id = "camera.reolink_video_doorbell_clear"; };
        }
        {
          service = "notify.mobile_app_pixel_8";
          data = {
            message = "Doorbell rings";
            data = {
              ttl = 0;
              priority = "high";
              image = "/media/local/front_door.jpg";
              actions = [
                { action = "URI"; title = "Open Reolink"; uri = "app://com.mcu.reolink"; }
              ];
            };
          };
        }
      ];
      mode = "single";
    }
    {
      id = "1705223239528";
      alias = "Plant light toggle";
      description = "";
      trigger = [
        { platform = "time"; at = "09:00:00"; id = "Morning"; }
        { platform = "time"; at = "19:00:00"; id = "Evening"; }
      ];
      condition = [ ];
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "Morning" ]; }];
            sequence = [{ service = "light.turn_on"; target = { device_id = "6ef89c16b98084bfc4344652a0baf4e0"; }; data = { }; }];
          }
          {
            conditions = [{ condition = "trigger"; id = [ "Evening" ]; }];
            sequence = [{ service = "light.turn_off"; target = { device_id = "6ef89c16b98084bfc4344652a0baf4e0"; }; data = { }; }];
          }
        ];
      }];
      mode = "single";
    }
    {
      id = "1700045924";
      alias = "Office light dim";
      description = "";
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "office_dim_up" ]; }];
            sequence = [{
              repeat = { sequence = [{ device_id = "11afd3425cb60c9990a447eb82bae007"; domain = "light"; entity_id = "5ce992fb6ec0aa3adaefc844c98d76f3"; type = "brightness_increase"; } { delay = { hours = 0; milliseconds = 100; minutes = 0; seconds = 0; }; }]; while = [{ condition = "trigger"; id = [ "office_dim_up" ]; }]; };
            }];
          }
          {
            conditions = [{ condition = "trigger"; id = [ "office_dim_down" ]; }];
            sequence = [{
              repeat = { sequence = [{ device_id = "11afd3425cb60c9990a447eb82bae007"; domain = "light"; entity_id = "5ce992fb6ec0aa3adaefc844c98d76f3"; type = "brightness_decrease"; } { delay = { hours = 0; milliseconds = 100; minutes = 0; seconds = 0; }; }]; while = [{ condition = "trigger"; id = [ "office_dim_down" ]; }]; };
            }];
          }
        ];
      }];
      condition = [ ];
      mode = "restart";
      trigger = [
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "office_dim_up"; platform = "device"; subtype = "dim_up"; type = "remote_button_long_press"; }
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "office_dim_up_release"; platform = "device"; subtype = "dim_up"; type = "remote_button_long_release"; }
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "office_dim_down"; platform = "device"; subtype = "dim_down"; type = "remote_button_long_press"; }
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "office_dim_down_release"; platform = "device"; subtype = "dim_down"; type = "remote_button_long_release"; }
      ];
    }
    {
      id = "1700040918";
      alias = "Kitchen light dim";
      description = "";
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "kitchen_dim_up" ]; }];
            sequence = [{
              repeat = { sequence = [{ device_id = "dfab35ab8c823997e867512bbbafa532"; domain = "light"; entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68"; type = "brightness_increase"; } { delay = { hours = 0; milliseconds = 100; minutes = 0; seconds = 0; }; }]; while = [{ condition = "trigger"; id = [ "kitchen_dim_up" ]; }]; };
            }];
          }
          {
            conditions = [{ condition = "trigger"; id = [ "kitchen_dim_down" ]; }];
            sequence = [{
              repeat = { sequence = [{ device_id = "dfab35ab8c823997e867512bbbafa532"; domain = "light"; entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68"; type = "brightness_decrease"; } { delay = { hours = 0; milliseconds = 100; minutes = 0; seconds = 0; }; }]; while = [{ condition = "trigger"; id = [ "kitchen_dim_down" ]; }]; };
            }];
          }
        ];
      }];
      condition = [ ];
      mode = "restart";
      trigger = [
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "kitchen_dim_up"; platform = "device"; subtype = "dim_up"; type = "remote_button_long_press"; }
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "kitchen_dim_up_release"; platform = "device"; subtype = "dim_up"; type = "remote_button_long_release"; }
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "kitchen_dim_down"; platform = "device"; subtype = "dim_down"; type = "remote_button_long_press"; }
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "kitchen_dim_down_release"; platform = "device"; subtype = "dim_down"; type = "remote_button_long_release"; }
      ];
    }
    {
      id = "1700044534";
      alias = "Office light toggle";
      description = "";
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "on" ]; }];
            sequence = [{ service = "light.turn_on"; metadata = { }; data = { kelvin = 2700; brightness_pct = 65; }; target = { entity_id = [ "light.ikea_of_sweden_stoftmoln_ceiling_wall_lamp_ww24_light" ]; }; }];
          }
          {
            conditions = [{ condition = "trigger"; id = [ "off" ]; }];
            sequence = [{ service = "light.turn_off"; metadata = { }; data = { }; target = { entity_id = [ "light.ikea_of_sweden_stoftmoln_ceiling_wall_lamp_ww24_light" ]; }; }];
          }
        ];
      }];
      condition = [ ];
      mode = "single";
      trigger = [
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "on"; platform = "device"; subtype = "turn_on"; type = "remote_button_short_press"; }
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "off"; platform = "device"; subtype = "turn_off"; type = "remote_button_short_press"; }
      ];
    }
    {
      id = "1700036303";
      alias = "Kitchen light toggle";
      description = "";
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "on" ]; }];
            sequence = [{ device_id = "dfab35ab8c823997e867512bbbafa532"; domain = "light"; entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68"; type = "turn_on"; }];
          }
          {
            conditions = [{ condition = "trigger"; id = [ "off" ]; }];
            sequence = [{ device_id = "dfab35ab8c823997e867512bbbafa532"; domain = "light"; entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68"; type = "turn_off"; }];
          }
        ];
      }];
      condition = [ ];
      mode = "single";
      trigger = [
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "on"; platform = "device"; subtype = "turn_on"; type = "remote_button_short_press"; }
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "off"; platform = "device"; subtype = "turn_off"; type = "remote_button_short_press"; }
      ];
    }
    {
      id = "1710336460";
      alias = "Living room light toggle";
      description = "";
      trigger = [
        { device_id = "443456bd59ce8a49e36e4820d6548165"; domain = "zha"; platform = "device"; type = "remote_button_short_press"; subtype = "turn_on"; id = "on"; }
        { device_id = "443456bd59ce8a49e36e4820d6548165"; domain = "zha"; platform = "device"; type = "remote_button_short_press"; subtype = "turn_off"; id = "off"; }
      ];
      condition = [ ];
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "on" ]; }];
            sequence = [{ service = "light.turn_on"; target = { entity_id = [ "light.dresden_elektronik_raspbee_ii_kitchenlights" "light.dresden_elektronik_raspbee_ii_livingroomlights" ]; }; data = { brightness_pct = 70; kelvin = 2700; }; }];
          }
          {
            conditions = [{ condition = "trigger"; id = [ "off" ]; }];
            sequence = [{ service = "light.turn_off"; target = { entity_id = [ "light.dresden_elektronik_raspbee_ii_kitchenlights" "light.dresden_elektronik_raspbee_ii_livingroomlights" ]; }; data = { }; }];
          }
        ];
      }];
      mode = "single";
    }
    {
      id = "1710357901";
      alias = "Laundry on";
      initial_state = true;
      description = "";
      trigger = [
        { platform = "numeric_state"; entity_id = [ "sensor.garage_socket_power" ]; for = { hours = 0; minutes = 3; seconds = 0; }; above = 3; }
      ];
      condition = [
        { condition = "state"; entity_id = "binary_sensor.laundry_state"; state = "off"; }
      ];
      action = [
        { service = "mqtt.publish"; metadata = { }; data = { retain = true; topic = "home/laundry/state"; payload = "ON"; }; }
      ];
      mode = "single";
    }
    {
      id = "1710357902";
      alias = "Laundry off";
      initial_state = true;
      description = "";
      trigger = [
        { platform = "numeric_state"; entity_id = [ "sensor.garage_socket_power" ]; for = { hours = 0; minutes = 3; seconds = 0; }; below = 3; }
      ];
      condition = [
        { condition = "state"; entity_id = "binary_sensor.laundry_state"; state = "on"; }
      ];
      action = [
        { service = "mqtt.publish"; metadata = { }; data = { retain = true; topic = "home/laundry/state"; payload = "OFF"; }; }
      ];
      mode = "single";
    }
    {
      id = "1710357903";
      alias = "Laundry notify";
      description = "";
      trigger = [
        { platform = "state"; entity_id = [ "binary_sensor.laundry_state" ]; }
      ];
      condition = [ ];
      action = [
        { service = "notify.mobile_app_pixel_8"; metadata = { }; data = { data = { priority = "high"; ttl = 0; }; message = "Laundry is {{ states.binary_sensor.laundry_state.state }} now"; }; }
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
    http = {
      ip_ban_enabled = true;
      login_attempts_threshold = 5;
      server_port = 8124;
      use_x_forwarded_for = true;
      trusted_proxies = [
        "127.0.0.1"
      ];
    };
    frontend.themes = "!include_dir_merge_named themes";
    cover = [
      {
        platform = "group";
        name = "Shutters";
        unique_id = "cover.shutters";
        entities = [
          "cover.kitchen_shutter"
          "cover.living_room_shutter_door"
          "cover.living_room_shutter_window"
        ];
      }
    ];
    mqtt = {
      binary_sensor = [
        {
          name = "Laundry State";
          device_class = "running";
          icon = "mdi:washing-machine";
          state_topic = "home/laundry/state";
          unique_id = "laundry_state";
        }
      ];
    };
    homeassistant = {
      name = "Home";
      latitude = secrets.address.latitude;
      longitude = secrets.address.longitude;
      elevation = secrets.address.elevation;
      unit_system = "metric";
      time_zone = "Europe/Amsterdam";
      customize = {
        "automation.doorbell".icon = "mdi:doorbell-video";
        "automation.laundry_off".icon = "mdi:washing-machine-off";
        "automation.laundry_notify".icon = "mdi:washing-machine-alert";
        "automation.laundry_on".icon = "mdi:washing-machine";
        "automation.toggle_living_room_lights".icon = "mdi:home-lightbulb-outline";
        "binary_sensor.ikea_of_sweden_tradfri_motion_sensor_motion".friendly_name = "Office motion";
        "cover.kitchen_shutter".device_class = "shutter";
        "cover.living_room_awning" = { device_class = "awning"; icon = "mdi:awning-outline"; };
        "cover.living_room_shutter_door".device_class = "shutter";
        "cover.living_room_shutter_window".device_class = "shutter";
        "cover.shutters".device_class = "shutter";
        "light.dresden_elektronik_raspbee_ii_kitchenlights" = { friendly_name = "Kitchen light"; icon = "mdi:lightbulb-group"; };
        "light.dresden_elektronik_raspbee_ii_livingroomlights" = { friendly_name = "Living room light"; icon = "mdi:lightbulb-group"; };
        "light.ikea_of_sweden_stoftmoln_ceiling_wall_lamp_ww24_light" = { friendly_name = "Office light"; icon = "mdi:ceiling-light"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_0" = { friendly_name = "Spot #0"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_1" = { friendly_name = "Spot #1"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_2" = { friendly_name = "Spot #2"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_3" = { friendly_name = "Spot #3"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_4" = { friendly_name = "Spot #4"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_5" = { friendly_name = "Spot #5"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_6" = { friendly_name = "Spot #6"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_7" = { friendly_name = "Spot #7"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_8" = { friendly_name = "Spot #8"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_9" = { friendly_name = "Spot #9"; icon = "mdi:lightbulb-spot"; };
        "light.ikea_of_sweden_tradfri_driver_10w_light" = { friendly_name = "Table top light"; icon = "mdi:led-strip-variant"; };
        "switch.backyard_main".friendly_name = "Backyard light";
        "switch.garage_socket".device_class = "outlet";
        "switch.kitchen_floor_heating".icon = "mdi:heating-coil";
        "switch.living_room_floor_heating".icon = "mdi:heating-coil";
      };
    };
    recorder.db_url = "postgresql://homeassistant@/homeassistant";
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
    zha.zigpy_config.ota = {
      ikea_provider = true;
      otau_directory = "/config/zigpy_ota";
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
      local homeassistant homeassistant ident map=ha
    '';
    identMap = ''
      ha root homeassistant
    '';
    ensureDatabases = [ "homeassistant" ];
    ensureUsers = [
      { name = "homeassistant"; ensureDBOwnership = true; }
    ];
  };

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
          "/media:/media"
        ];
        environment = {
          TZ = "Europe/Amsterdam";
        };
        image = "ghcr.io/home-assistant/home-assistant:2024.9.1";
        extraOptions = [
          "--device=/dev/ttyACM0"
          "--device=/dev/ttyUSB0"
          "--privileged"
          "--network=host"
        ];
      };
      # esphome = {
      #   volumes = [
      #     "/var/lib/homeassistant/esphome:/config"
      #   ];
      #   image = "ghcr.io/esphome/esphome:2024.3.2";
      #   ports = [
      #     "6052:6052"
      #   ];
      #   extraOptions = [
      #     "--init"
      #   ];
      # };
    };
  };
}
