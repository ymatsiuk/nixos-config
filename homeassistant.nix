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
      trigger = [{
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
        }];
      condition = [{
        condition = "sun";
        before = "sunrise";
        after = "sunset";
      }];
      action = [{
        choose = [{
          conditions = [{
            condition = "trigger";
            id = [ "office_motion" ];
          }];
          sequence = [{
            service = "light.turn_on";
            target = { area_id = "office"; };
            data = { brightness_pct = 50; };
          }];
        }
          {
            conditions = [{
              condition = "trigger";
              id = [ "office_no_motion" ];
            }];
            sequence = [{
              delay = { hours = 0; minutes = 2; seconds = 0; milliseconds = 0; };
            }
              { service = "light.turn_off"; target = { area_id = "office"; }; data = { }; }];
          }];
      }];
      mode = "single";
    }
    {
      id = "1702295114892";
      alias = "Smart laundry";
      description = "";
      trigger = [{
        type = "power";
        platform = "device";
        device_id = "84683e13b344f125337275de40cbd019";
        entity_id = "1675fcb4fde3f00ca03cbc62c268fe37";
        domain = "sensor";
        below = 5;
        for = { hours = 0; minutes = 5; seconds = 0; };
      }];
      condition = [ ];
      action = [{
        service = "notify.mobile_app_pixel_8";
        data = {
          message = "Laundry cycle has finished";
          data = { ttl = 0; priority = "high"; };
        };
      }];
      mode = "single";
    }
    {
      id = "1702981478448";
      alias = "Doorbell";
      description = "";
      trigger = [{
        type = "turned_on";
        platform = "device";
        device_id = "6ec43bd1e46a027cceea113df0b4ae4a";
        entity_id = "c675ef6e1b21cec358f651083e6e6f30";
        domain = "binary_sensor";
      }];
      condition = [ ];
      action = [{
        service = "notify.mobile_app_pixel_8";
        data = {
          title = "Doorbell rings";
          data = {
            ttl = 0;
            priority = "high";
            image = "/api/camera_proxy/camera.reolink_video_doorbell_sub";
            actions = [
              {
                action = "URI";
                title = "Open HA";
                uri = "/lovelace/0";
              }
              {
                action = "URI";
                title = "Open Reolink";
                uri = "app://com.mcu.reolink";
              }
            ];
          };
          message = "Someone's at the door";
        };
      }];
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
      action = [{
        choose = [{
          conditions = [{
            condition = "trigger";
            id = [ "Morning" ];
          }];
          sequence = [{
            service = "light.turn_on";
            target = { device_id = "6ef89c16b98084bfc4344652a0baf4e0"; };
            data = { };
          }];
        }
          {
            conditions = [{
              condition = "trigger";
              id = [ "Evening" ];
            }];
            sequence = [{
              service = "light.turn_off";
              target = { device_id = "6ef89c16b98084bfc4344652a0baf4e0"; };
              data = { };
            }];
          }];
      }];
      mode = "single";
    }
    {
      alias = "rodret";
      description = "";
      id = "1700336750";
      use_blueprint = {
        input = {
          off_press_action = [{
            service = "light.turn_off";
            target = {
              entity_id = [
                "light.group_kitchen"
                "light.group_living_room"
                "light.ikea_of_sweden_tradfri_driver_10w_light"
              ];
            };
          }];
          on_press_action = [{
            data = {
              brightness_pct = "60";
              kelvin = "2700";
            };
            service = "light.turn_on";
            target = {
              entity_id = [
                "light.group_kitchen"
                "light.group_living_room"
                "light.ikea_of_sweden_tradfri_driver_10w_light"
              ];
            };
          }];
          remote_device = "443456bd59ce8a49e36e4820d6548165";
        };
        path = "damru/ikea-rodret_E2201_ZHA-Z2M_control-anything.yaml";
      };
    }
    {
      id = "1700045924";
      alias = "Dim office light";
      description = "";
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "office_dim_up" ]; }];
            sequence = [{
              repeat = {
                sequence = [{ device_id = "11afd3425cb60c9990a447eb82bae007"; domain = "light"; entity_id = "5ce992fb6ec0aa3adaefc844c98d76f3"; type = "brightness_increase"; } { delay = { hours = 0; milliseconds = 100; minutes = 0; seconds = 0; }; }];
                while = [{ condition = "trigger"; id = [ "office_dim_up" ]; }];
              };
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
      trigger = [{
        device_id = "513fe3edce40d4f49349dfd9e9b0d007";
        domain = "zha";
        id = "office_dim_up";
        platform = "device";
        subtype = "dim_up";
        type = "remote_button_long_press";
      }
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "office_dim_up_release"; platform = "device"; subtype = "dim_up"; type = "remote_button_long_release"; }
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "office_dim_down"; platform = "device"; subtype = "dim_down"; type = "remote_button_long_press"; }
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "office_dim_down_release"; platform = "device"; subtype = "dim_down"; type = "remote_button_long_release"; }];
    }
    {
      id = "1700040918";
      alias = "Dim kitchen light";
      description = "";
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "kitchen_dim_up" ]; }];
            sequence = [{
              repeat = {
                sequence = [{ device_id = "dfab35ab8c823997e867512bbbafa532"; domain = "light"; entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68"; type = "brightness_increase"; } { delay = { hours = 0; milliseconds = 100; minutes = 0; seconds = 0; }; }];
                while = [{ condition = "trigger"; id = [ "kitchen_dim_up" ]; }];
              };
            }];
          }
          {
            conditions = [{ condition = "trigger"; id = [ "kitchen_dim_down" ]; }];
            sequence = [{
              repeat = {
                sequence = [{
                  device_id = "dfab35ab8c823997e867512bbbafa532";
                  domain = "light";
                  entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68";
                  type = "brightness_decrease";
                }
                  { delay = { hours = 0; milliseconds = 100; minutes = 0; seconds = 0; }; }];
                while = [{ condition = "trigger"; id = [ "kitchen_dim_down" ]; }];
              };
            }];
          }
        ];
      }];
      condition = [ ];
      mode = "restart";
      trigger = [{
        device_id = "6f7e9b5860763551a83df23c1dbef7c4";
        domain = "zha";
        id = "kitchen_dim_up";
        platform = "device";
        subtype = "dim_up";
        type = "remote_button_long_press";
      }
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "kitchen_dim_up_release"; platform = "device"; subtype = "dim_up"; type = "remote_button_long_release"; }
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "kitchen_dim_down"; platform = "device"; subtype = "dim_down"; type = "remote_button_long_press"; }
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "kitchen_dim_down_release"; platform = "device"; subtype = "dim_down"; type = "remote_button_long_release"; }];
    }
    {
      id = "1700044534";
      alias = "Toggle office light";
      description = "";
      action = [{
        choose = [
          {
            conditions = [{ condition = "trigger"; id = [ "office_light_on" ]; }];
            sequence = [{ device_id = "11afd3425cb60c9990a447eb82bae007"; domain = "light"; entity_id = "5ce992fb6ec0aa3adaefc844c98d76f3"; type = "turn_on"; }];
          }
          {
            conditions = [{ condition = "trigger"; id = [ "office_light_off" ]; }];
            sequence = [{ device_id = "11afd3425cb60c9990a447eb82bae007"; domain = "light"; entity_id = "5ce992fb6ec0aa3adaefc844c98d76f3"; type = "turn_off"; }];
          }
        ];
      }];
      condition = [ ];
      mode = "single";
      trigger = [{
        device_id = "513fe3edce40d4f49349dfd9e9b0d007";
        domain = "zha";
        id = "office_light_on";
        platform = "device";
        subtype = "turn_on";
        type = "remote_button_short_press";
      }
        { device_id = "513fe3edce40d4f49349dfd9e9b0d007"; domain = "zha"; id = "office_light_off"; platform = "device"; subtype = "turn_off"; type = "remote_button_short_press"; }];
    }
    {
      id = "1700036303";
      alias = "Toggle kitchen light";
      description = "";
      action = [
        {
          choose = [
            {
              conditions = [{ condition = "trigger"; id = [ "kitchen_light_on" ]; }];
              sequence = [{ device_id = "dfab35ab8c823997e867512bbbafa532"; domain = "light"; entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68"; type = "turn_on"; }];
            }
            {
              conditions = [{ condition = "trigger"; id = [ "kitchen_light_off" ]; }];
              sequence = [{ device_id = "dfab35ab8c823997e867512bbbafa532"; domain = "light"; entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68"; type = "turn_off"; }];
            }
          ];
        }
      ];
      condition = [ ];
      mode = "single";
      trigger = [{
        device_id = "6f7e9b5860763551a83df23c1dbef7c4";
        domain = "zha";
        id = "kitchen_light_on";
        platform = "device";
        subtype = "turn_on";
        type = "remote_button_short_press";
      }
        { device_id = "6f7e9b5860763551a83df23c1dbef7c4"; domain = "zha"; id = "kitchen_light_off"; platform = "device"; subtype = "turn_off"; type = "remote_button_short_press"; }];
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
    frontend.themes = "!include_dir_merge_named themes";
    # TODO: add all light groups
    # light = [
    #   {
    #     platform = "group";
    #     name = "Lights";
    #     unique_id = "light.lights";
    #     entities = [
    #       "light.backyard"
    #       "light.kitchen"
    #       "light.living_room"
    #       "light.office"
    #     ];
    #   }
    #   {
    #     platform = "group";
    #     name = "Kitchen";
    #     unique_id = "light.kitchen";
    #     entities = [
    #       ""
    #     ];
    #   }
    #   {
    #     platform = "group";
    #     name = "Living room";
    #     unique_id = "light.living_room";
    #     entities = [
    #       ""
    #     ];
    #   }
    #   {
    #     platform = "group";
    #     name = "Office";
    #     unique_id = "light.office";
    #     entities = [
    #       ""
    #     ];
    #   }
    # ];
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
    homeassistant = {
      name = "Home";
      latitude = secrets.address.latitude;
      longitude = secrets.address.longitude;
      elevation = secrets.address.elevation;
      unit_system = "metric";
      time_zone = "Europe/Amsterdam";
      customize = {
        "cover.kitchen_shutter".device_class = "shutter";
        "cover.living_room_awning" = { device_class = "awning"; icon = "mdi:awning-outline"; };
        "cover.living_room_shutter_door".device_class = "shutter";
        "cover.living_room_shutter_window".device_class = "shutter";
        "cover.shutters".device_class = "shutter";
        "ikea_of_sweden_tradfri_motion_sensor_motion".friendly_name = "Office motion";
        "light.ikea_of_sweden_stoftmoln_ceiling_wall_lamp_ww24_light" = { friendly_name = "Office light"; icon = "mdi:ceiling-light"; };
        "light.ikea_of_sweden_tradfri_driver_10w_light" = { friendly_name = "Table top light"; icon = "mdi:led-strip-variant"; };
        "switch.backyard_main".friendly_name = "Backyard light";
        "switch.garage_dryer_socket".device_class = "outlet";
        "switch.kitchen_floor_heating".icon = "mdi:heating-coil";
        "switch.living_room_floor_heating".icon = "mdi:heating-coil";
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
        image = "ghcr.io/home-assistant/home-assistant:2024.3.0";
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
