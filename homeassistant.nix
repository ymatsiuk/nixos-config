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
        {
          type = "turned_on";
          platform = "device";
          device_id = "6ec43bd1e46a027cceea113df0b4ae4a";
          entity_id = "657e87321790b350d32c1b2208eba789";
          domain = "binary_sensor";
        }
      ];
      condition = [ ];
      action = [
        {
          service = "camera.snapshot";
          data = {
            filename = "/media/front_door.jpg";
          };
          target = {
            entity_id = "camera.reolink_video_doorbell_clear";
          };
        }
        {
          service = "notify.family";
          data = {
            message = "Doorbell rings";
            data = {
              ttl = 0;
              priority = "high";
              image = "/media/local/front_door.jpg";
              actions = [
                {
                  action = "URI";
                  title = "Open Reolink";
                  uri = "app://com.mcu.reolink";
                }
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
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "Morning" ];
                }
              ];
              sequence = [
                {
                  service = "light.turn_on";
                  target = {
                    device_id = "6ef89c16b98084bfc4344652a0baf4e0";
                  };
                  data = { };
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "Evening" ];
                }
              ];
              sequence = [
                {
                  service = "light.turn_off";
                  target = {
                    device_id = "6ef89c16b98084bfc4344652a0baf4e0";
                  };
                  data = { };
                }
              ];
            }
          ];
        }
      ];
      mode = "single";
    }
    {
      id = "1700040918";
      alias = "Kitchen light dim";
      description = "";
      action = [
        {
          choose = [
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "kitchen_dim_up" ];
                }
              ];
              sequence = [
                {
                  repeat = {
                    sequence = [
                      {
                        device_id = "dfab35ab8c823997e867512bbbafa532";
                        domain = "light";
                        entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68";
                        type = "brightness_increase";
                      }
                      {
                        delay = {
                          hours = 0;
                          milliseconds = 100;
                          minutes = 0;
                          seconds = 0;
                        };
                      }
                    ];
                    while = [
                      {
                        condition = "trigger";
                        id = [ "kitchen_dim_up" ];
                      }
                    ];
                  };
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "kitchen_dim_down" ];
                }
              ];
              sequence = [
                {
                  repeat = {
                    sequence = [
                      {
                        device_id = "dfab35ab8c823997e867512bbbafa532";
                        domain = "light";
                        entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68";
                        type = "brightness_decrease";
                      }
                      {
                        delay = {
                          hours = 0;
                          milliseconds = 100;
                          minutes = 0;
                          seconds = 0;
                        };
                      }
                    ];
                    while = [
                      {
                        condition = "trigger";
                        id = [ "kitchen_dim_down" ];
                      }
                    ];
                  };
                }
              ];
            }
          ];
        }
      ];
      condition = [ ];
      mode = "restart";
      trigger = [
        {
          device_id = "6f7e9b5860763551a83df23c1dbef7c4";
          domain = "zha";
          id = "kitchen_dim_up";
          platform = "device";
          subtype = "dim_up";
          type = "remote_button_long_press";
        }
        {
          device_id = "6f7e9b5860763551a83df23c1dbef7c4";
          domain = "zha";
          id = "kitchen_dim_up_release";
          platform = "device";
          subtype = "dim_up";
          type = "remote_button_long_release";
        }
        {
          device_id = "6f7e9b5860763551a83df23c1dbef7c4";
          domain = "zha";
          id = "kitchen_dim_down";
          platform = "device";
          subtype = "dim_down";
          type = "remote_button_long_press";
        }
        {
          device_id = "6f7e9b5860763551a83df23c1dbef7c4";
          domain = "zha";
          id = "kitchen_dim_down_release";
          platform = "device";
          subtype = "dim_down";
          type = "remote_button_long_release";
        }
      ];
    }
    {
      id = "1700036303";
      alias = "Kitchen light toggle";
      description = "";
      action = [
        {
          choose = [
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "on" ];
                }
              ];
              sequence = [
                {
                  device_id = "dfab35ab8c823997e867512bbbafa532";
                  domain = "light";
                  entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68";
                  type = "turn_on";
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "off" ];
                }
              ];
              sequence = [
                {
                  device_id = "dfab35ab8c823997e867512bbbafa532";
                  domain = "light";
                  entity_id = "a44ba48e3a06da7869a0bc6da4cf8f68";
                  type = "turn_off";
                }
              ];
            }
          ];
        }
      ];
      condition = [ ];
      mode = "single";
      trigger = [
        {
          device_id = "6f7e9b5860763551a83df23c1dbef7c4";
          domain = "zha";
          id = "on";
          platform = "device";
          subtype = "turn_on";
          type = "remote_button_short_press";
        }
        {
          device_id = "6f7e9b5860763551a83df23c1dbef7c4";
          domain = "zha";
          id = "off";
          platform = "device";
          subtype = "turn_off";
          type = "remote_button_short_press";
        }
      ];
    }
    {
      id = "1710336460";
      alias = "Living room light toggle";
      description = "";
      trigger = [
        {
          device_id = "443456bd59ce8a49e36e4820d6548165";
          domain = "zha";
          platform = "device";
          type = "remote_button_short_press";
          subtype = "turn_on";
          id = "on";
        }
        {
          device_id = "443456bd59ce8a49e36e4820d6548165";
          domain = "zha";
          platform = "device";
          type = "remote_button_short_press";
          subtype = "turn_off";
          id = "off";
        }
      ];
      condition = [ ];
      action = [
        {
          choose = [
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "on" ];
                }
              ];
              sequence = [
                {
                  service = "light.turn_on";
                  target = {
                    entity_id = [
                      "light.dresden_elektronik_raspbee_ii_kitchenlights"
                      "light.dresden_elektronik_raspbee_ii_livingroomlights"
                    ];
                  };
                  data = {
                    brightness_pct = 70;
                    kelvin = 2700;
                  };
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "off" ];
                }
              ];
              sequence = [
                {
                  service = "light.turn_off";
                  target = {
                    entity_id = [
                      "light.dresden_elektronik_raspbee_ii_kitchenlights"
                      "light.dresden_elektronik_raspbee_ii_livingroomlights"
                    ];
                  };
                  data = { };
                }
              ];
            }
          ];
        }
      ];
      mode = "single";
    }
    {
      id = "1734518766";
      alias = "Laundry";
      description = "Change state of laundry sensor based on power consumption of washing machine";
      triggers = [
        {
          below = 3;
          entity_id = [ "sensor.garage_socket_power" ];
          for = {
            hours = 0;
            minutes = 3;
            seconds = 0;
          };
          id = "off";
          trigger = "numeric_state";
        }
        {
          above = 3;
          entity_id = [ "sensor.garage_socket_power" ];
          for = {
            hours = 0;
            minutes = 3;
            seconds = 0;
          };
          id = "on";
          trigger = "numeric_state";
        }
      ];
      conditions = [ ];
      actions = [
        {
          choose = [
            {
              conditions = [
                {
                  condition = "and";
                  conditions = [
                    {
                      condition = "trigger";
                      id = [ "on" ];
                    }
                    {
                      condition = "state";
                      entity_id = "binary_sensor.laundry_state";
                      state = "off";
                    }
                  ];
                }
              ];
              sequence = [
                {
                  action = "mqtt.publish";
                  data = {
                    payload = "ON";
                    retain = true;
                    topic = "home/laundry/state";
                  };
                  metadata = { };
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "and";
                  conditions = [
                    {
                      condition = "trigger";
                      id = [ "off" ];
                    }
                    {
                      condition = "state";
                      entity_id = "binary_sensor.laundry_state";
                      state = "on";
                    }
                  ];
                }
              ];
              sequence = [
                {
                  action = "mqtt.publish";
                  data = {
                    payload = "OFF";
                    retain = true;
                    topic = "home/laundry/state";
                  };
                  metadata = { };
                }
                {
                  action = "notify.family";
                  data = {
                    data = {
                      priority = "high";
                      ttl = 0;
                    };
                    message = "Laundry is {{ states.binary_sensor.laundry_state.state }} now";
                  };
                  metadata = { };
                }
              ];
            }
          ];
        }
      ];
      mode = "single";
    }
    {
      id = "1734462148";
      alias = "Shutters vacation";
      description = "Open shutters on sunrise and close on sunset (vacation mode)";
      mode = "single";
      triggers = [
        {
          trigger = "sun";
          id = "sunrise";
          event = "sunrise";
          offset = 0;
        }
        {
          trigger = "sun";
          id = "sunset";
          event = "sunset";
          offset = 0;
        }
      ];
      conditions = [ ];
      actions = [
        {
          choose = [
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "sunrise" ];
                }
              ];
              sequence = [
                {
                  action = "cover.open_cover";
                  data = { };
                  metadata = { };
                  target = {
                    entity_id = [
                      "cover.living_room_shutter_door"
                      "cover.living_room_shutter_window"
                    ];
                  };
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "sunset" ];
                }
              ];
              sequence = [
                {
                  action = "cover.close_cover";
                  data = { };
                  metadata = { };
                  target = {
                    entity_id = [
                      "cover.living_room_shutter_door"
                      "cover.living_room_shutter_window"
                    ];
                  };
                }
              ];
            }
          ];
        }
      ];
    }
    {
      alias = "Shutters";
      id = "1734459054";
      description = "Open shutters on sunrise and close on sunset";
      mode = "single";
      triggers = [
        {
          trigger = "sun";
          id = "sunrise";
          event = "sunrise";
          offset = 0;
        }
        {
          trigger = "sun";
          id = "sunset";
          event = "sunset";
          offset = 0;
        }
      ];
      conditions = [ ];
      actions = [
        {
          choose = [
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "sunrise" ];
                }
                {
                  condition = "and";
                  conditions = [
                    {
                      condition = "state";
                      entity_id = "cover.shutters";
                      state = "closed";
                    }
                  ];
                }
              ];
              sequence = [
                {
                  action = "cover.open_cover";
                  metadata = { };
                  data = { };
                  target = {
                    entity_id = "cover.shutters";
                  };
                }
                {
                  action = "light.turn_off";
                  metadata = { };
                  data = { };
                  target = {
                    area_id = [
                      "kitchen"
                      "living_room"
                    ];
                  };
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "sunset" ];
                }
                {
                  condition = "and";
                  conditions = [
                    {
                      condition = "state";
                      entity_id = "cover.shutters";
                      state = "open";
                    }
                  ];
                }
              ];
              sequence = [
                {
                  action = "cover.close_cover";
                  metadata = { };
                  data = { };
                  target = {
                    entity_id = "cover.shutters";
                  };
                }
                {
                  action = "light.turn_on";
                  metadata = { };
                  data = { };
                  target = {
                    area_id = [
                      "kitchen"
                      "living_room"
                    ];
                  };
                }
              ];
            }
          ];
        }
      ];
    }
    {
      alias = "Failed login notify";
      id = "1731264884";
      description = "";
      triggers = [
        {
          update_type = "added";
          trigger = "persistent_notification";
        }
      ];
      conditions = [
        {
          condition = "template";
          value_template = "{% set message = trigger.notification.message %} {{'Too many login attempts' in message or\n  'invalid authentication' in message or 'login attempt' in message}}\n";
        }
      ];
      actions = [
        {
          data = {
            title = "{% set title = trigger.notification.title %} ⚠️Ha Main: {{title}}⚠️\n";
            message = "{% set message = trigger.notification.message %} {% set now = now().strftime('%d %b: %X') %} {% if 'Too many login attempts' in message %}\n Login notification: {{now}}: {{message}}\n{% elif 'invalid authentication' in message or 'login attempt' in message %}\n  Login notification: {{now}}: {{message}}\n  IP {{message.split('from ')[1]}}\n{% else %}\n  Login notification other: {{now}}: {{message}}\n{% endif %}\n";
          };
          action = "notify.mobile_app_ymatsiuk";
        }
      ];
    }
    {
      alias = "Fan";
      id = "1734461719";
      description = "Set fan to maximum speed for 25 min when humidity spikes higher than 60% for more than 5 min";
      mode = "restart";
      triggers = [
        {
          trigger = "state";
          entity_id = [ "binary_sensor.humidity_rising" ];
          from = "off";
          to = "on";
        }
      ];
      conditions = [ ];
      actions = [
        {
          action = "fan.set_percentage";
          metadata = { };
          data = {
            percentage = 100;
          };
          target = {
            entity_id = "fan.itho_wifi_itho_itho_fan";
          };
        }
        {
          wait_for_trigger = [
            {
              trigger = "state";
              entity_id = [ "binary_sensor.humidity_rising" ];
              from = "off";
              to = "on";
            }
          ];
          timeout = {
            hours = 0;
            minutes = 25;
            seconds = 0;
            milliseconds = 0;
          };
          continue_on_timeout = true;
        }
        {
          action = "fan.set_percentage";
          metadata = { };
          data = {
            percentage = 15;
          };
          target = {
            entity_id = "fan.itho_wifi_itho_itho_fan";
          };
        }
      ];
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
      {
        platform = "group";
        name = "Living room shutters";
        unique_id = "cover.living_room_shutters";
        entities = [
          "cover.living_room_shutter_door"
          "cover.living_room_shutter_window"
        ];
      }
    ];
    notify = [
      {
        platform = "group";
        name = "Family";
        services = [
          { action = "mobile_app_imatsiuk"; }
          { action = "mobile_app_ymatsiuk"; }
        ];
      }
    ];
    binary_sensor = [
      {
        platform = "threshold";
        name = "humidity_rising";
        entity_id = "sensor.humidity_derivative";
        device_class = "moisture";
        upper = 0;
        hysteresis = 0.1;
      }
    ];
    sensor = [
      {
        platform = "derivative";
        name = "humidity_derivative";
        source = "sensor.itho_wifi_itho_itho_humidity";
        round = 0;
        unit_time = "min";
        time_window = "00:05:00";
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
        "automation.failed_login_notify".icon = "mdi:home-alert-outline";
        "automation.fan".icon = "mdi:fan-auto";
        "automation.laundry".icon = "mdi:washing-machine";
        "automation.plant_lights".icon = "mdi:flower";
        "automation.shutters".icon = "mdi:window-shutter-auto";
        "automation.shutters_vacation".icon = "mdi:window-shutter-auto";
        "automation.toggle_living_room_lights".icon = "mdi:home-lightbulb-outline";
        "binary_sensor.ikea_of_sweden_tradfri_motion_sensor_motion".friendly_name = "Office motion";
        "cover.kitchen_shutter".device_class = "shutter";
        "cover.living_room_awning" = {
          device_class = "awning";
          icon = "mdi:awning-outline";
        };
        "cover.living_room_shutter_door".device_class = "shutter";
        "cover.living_room_shutter_window".device_class = "shutter";
        "cover.living_room_shutters".device_class = "shutter";
        "cover.shutters".device_class = "shutter";
        "light.dresden_elektronik_raspbee_ii_kitchenlights" = {
          friendly_name = "Kitchen light";
          icon = "mdi:lightbulb-group";
        };
        "light.dresden_elektronik_raspbee_ii_livingroomlights" = {
          friendly_name = "Living room light";
          icon = "mdi:lightbulb-group";
        };
        "light.ikea_of_sweden_stoftmoln_ceiling_wall_lamp_ww24_light" = {
          friendly_name = "Office light";
          icon = "mdi:ceiling-light";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_0" = {
          friendly_name = "Spot #0";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_1" = {
          friendly_name = "Spot #1";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_2" = {
          friendly_name = "Spot #2";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_3" = {
          friendly_name = "Spot #3";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_4" = {
          friendly_name = "Spot #4";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_5" = {
          friendly_name = "Spot #5";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_6" = {
          friendly_name = "Spot #6";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_7" = {
          friendly_name = "Spot #7";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_8" = {
          friendly_name = "Spot #8";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_bulb_gu10_ws_345lm_light_9" = {
          friendly_name = "Spot #9";
          icon = "mdi:lightbulb-spot";
        };
        "light.ikea_of_sweden_tradfri_driver_10w_light" = {
          friendly_name = "Table top light";
          icon = "mdi:led-strip-variant";
        };
        "switch.backyard_main".friendly_name = "Backyard light";
        "switch.garage_socket".device_class = "outlet";
        "switch.bathroom_floor_heating".icon = "mdi:heating-coil";
        "switch.kitchen_floor_heating".icon = "mdi:heating-coil";
        "switch.living_room_floor_heating".icon = "mdi:heating-coil";
      };
    };
    recorder.db_url = "postgresql://homeassistant@/homeassistant";
    prometheus = { };
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
      extra_providers = [ { type = "ikea"; } ];
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
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
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
      {
        name = "homeassistant";
        ensureDBOwnership = true;
      }
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
        image = "ghcr.io/home-assistant/home-assistant:2025.1.4";
        extraOptions = [
          "--device=/dev/ttyACM0"
          "--device=/dev/ttyUSB0"
          "--privileged"
          "--network=host"
        ];
      };
    };
  };
}
