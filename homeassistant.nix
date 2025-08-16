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
            percentage = 0;
          };
          target = {
            entity_id = "fan.itho_wifi_itho_itho_fan";
          };
        }
      ];
    }
    {
      id = "1710357903";
      alias = "Laundry notify";
      description = "Send notification when (dish) washing or drying is done";
      triggers = [
        {
          trigger = "state";
          entity_id = [ "binary_sensor.dishwasher" ];
          from = "on";
          to = "off";
          id = "dishwasher";
        }
        {
          trigger = "state";
          entity_id = [ "binary_sensor.washing_machine" ];
          from = "on";
          to = "off";
          id = "washer";
        }
        {
          trigger = "state";
          entity_id = [ "binary_sensor.tumble_dryer" ];
          from = "on";
          to = "off";
          id = "dryer";
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
                  id = [ "dishwasher" ];
                }
              ];
              sequence = [
                {
                  action = "notify.family";
                  data = {
                    data = {
                      priority = "high";
                      ttl = 0;
                    };
                    message = "{{state_attr('binary_sensor.dishwasher', 'friendly_name')}} is {{states('binary_sensor.dishwasher')}} now";
                  };
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "dryer" ];
                }
              ];
              sequence = [
                {
                  action = "notify.family";
                  data = {
                    data = {
                      priority = "high";
                      ttl = 0;
                    };
                    message = "{{state_attr('binary_sensor.tumble_dryer', 'friendly_name')}} is {{states('binary_sensor.tumble_dryer')}} now";
                  };
                }
              ];
            }
            {
              conditions = [
                {
                  condition = "trigger";
                  id = [ "washer" ];
                }
              ];
              sequence = [
                {
                  action = "notify.family";
                  data = {
                    data = {
                      priority = "high";
                      ttl = 0;
                    };
                    message = "{{state_attr('binary_sensor.washing_machine', 'friendly_name')}} is {{states('binary_sensor.washing_machine')}} now";
                  };
                }
              ];
            }
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
      binary_sensor = [ ];
    };
    utility_meter = {
      daily_office_energy = {
        source = "sensor.0x70b3d52b601329c7_energy";
        name = "Daily Office Energy";
        cycle = "daily";
      };
      monthly_office_energy = {
        source = "sensor.daily_office_energy";
        name = "Monthly Office Energy";
        cycle = "monthly";
      };
      monthly_dryer_energy = {
        source = "sensor.0x70b3d52b601329c7_energy";
        name = "Monthly Dryer Energy";
        cycle = "monthly";
      };
      monthly_washer_energy = {
        source = "sensor.0x70b3d52b601352e1_energy";
        name = "Monthly Washer Energy";
        cycle = "monthly";
      };
      monthly_rack_energy = {
        source = "sensor.0x70b3d52b60132af9_energy";
        name = "Monthly Rack Energy";
        cycle = "monthly";
      };

      daily_energy_offpeak = {
        source = "sensor.energy_consumed_tariff_1";
        name = "Daily Energy (Offpeak)";
        cycle = "daily";
      };
      daily_energy_peak = {
        source = "sensor.energy_consumed_tariff_2";
        name = "Daily Energy (Peak)";
        cycle = "daily";
      };
      daily_gas = {
        source = "sensor.gas_consumed";
        name = "Daily Gas";
        cycle = "daily";
      };
      monthly_energy_offpeak = {
        source = "sensor.energy_consumed_tariff_1";
        name = "Monthly Energy (Offpeak)";
        cycle = "monthly";
      };
      monthly_energy_peak = {
        source = "sensor.energy_consumed_tariff_2";
        name = "Monthly Energy (Peak)";
        cycle = "monthly";
      };
      monthly_gas = {
        source = "sensor.gas_consumed";
        name = "Monthly Gas";
        cycle = "monthly";
      };
    };
    template = [
      {
        sensor = [
          {
            name = "Daily Energy Total";
            device_class = "energy";
            unit_of_measurement = "kWh";
            state = "{% if is_number(states('sensor.daily_energy_offpeak')) and is_number(states('sensor.daily_energy_peak')) %}\n  {{ states('sensor.daily_energy_offpeak') | float + states('sensor.daily_energy_peak') | float }}\n{% else %}\n  None\n{% endif %}\n";
          }
          {
            name = "Monthly Energy Total";
            device_class = "energy";
            unit_of_measurement = "kWh";
            state = "{% if is_number(states('sensor.monthly_energy_offpeak')) and is_number(states('sensor.monthly_energy_peak')) %}\n  {{ states('sensor.monthly_energy_offpeak') | float + states('sensor.monthly_energy_peak') | float }}\n{% else %}\n  None\n{% endif %}";
          }
          {
            name = "Monthly Laundry Total";
            device_class = "energy";
            unit_of_measurement = "kWh";
            state = "{% if is_number(states('sensor.monthly_washer_energy')) and is_number(states('sensor.monthly_dryer_energy')) %}\n  {{ states('sensor.monthly_washer_energy') | float + states('sensor.monthly_dryer_energy') | float }}\n{% else %}\n  None\n{% endif %}";
          }
        ];
      }
      {
        binary_sensor = [
          {
            name = "Dishwasher";
            state = "{{ is_number(states('sensor.0x08b95ffffec66e5d_power')) and states('sensor.0x08b95ffffec66e5d_power')|float > 5 }}";
            icon = "mdi:dishwasher";
            delay_off.minutes = 10;
          }
          {
            name = "Washing Machine";
            state = "{{ is_number(states('sensor.0x70b3d52b601352e1_power')) and states('sensor.0x70b3d52b601352e1_power')|float > 0 }}";
            icon = "mdi:washing-machine";
          }
          {
            name = "Tumble Dryer";
            state = "{{ is_number(states('sensor.0x70b3d52b60135977_power')) and states('sensor.0x70b3d52b60135977_power')|float > 5 }}";
            icon = "mdi:tumble-dryer";
            delay_off.minutes = 10;
          }
        ];
      }
    ];
    switch = [
      {
        name = "Fluxer";
        platform = "flux";
        mode = "mired";
        disable_brightness_adjust = true;
        lights = [ "light.spots" ];
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
        "automation.doorbell".icon = "mdi:doorbell-video";
        "automation.failed_login_notify".icon = "mdi:home-alert-outline";
        "automation.fan".icon = "mdi:fan-auto";
        "automation.laundry_notify".icon = "mdi:washing-machine";
        "automation.plant_lights".icon = "mdi:flower";
        "automation.shutters".icon = "mdi:window-shutter-auto";
        "automation.shutters_vacation".icon = "mdi:window-shutter-auto";

        "cover.kitchen_shutter".device_class = "shutter";
        "cover.living_room_awning" = {
          device_class = "awning";
          icon = "mdi:awning-outline";
        };
        "cover.living_room_shutter_door".device_class = "shutter";
        "cover.living_room_shutter_window".device_class = "shutter";
        "cover.living_room_shutters".device_class = "shutter";
        "cover.shutters".device_class = "shutter";

        "switch.backyard_main".friendly_name = "Backyard light";
        "switch.bathroom_floor_heating".icon = "mdi:heating-coil";
        "switch.garage_socket".device_class = "outlet";
        "switch.kitchen_floor_heating".icon = "mdi:heating-coil";
        "switch.living_room_floor_heating".icon = "mdi:heating-coil";

        # Zigbee2MQTT devices:
        "binary_sensor.0x385b44fffe9aaacb_occupancy".friendly_name = "Office occupancy";
        "sensor.0x385b44fffe9aaacb_battery".friendly_name = "Office occupancy battery";
        "sensor.0x142d41fffe3f78db_battery".friendly_name = "Office Tradfri battery";
        "sensor.0xb43522fffe067126_battery".friendly_name = "Living room Rodret battery";
        "sensor.0xf4b3b1fffe44760b_battery".friendly_name = "Kitchen Tradfri battery";
        "sensor.0x00124b0029115ddb_battery".friendly_name = "Garage SNZB-02 battery";
        "sensor.0x00124b0029124530_battery".friendly_name = "Living room SNZB-02 battery";
        "light.spots" = {
          friendly_name = "Spot lights";
          icon = "mdi:lightbulb-spot";
        };
        "light.kitchen_lights" = {
          friendly_name = "Kitchen light";
          icon = "mdi:lightbulb-group";
        };
        "light.living_room_lights" = {
          friendly_name = "Living room light";
          icon = "mdi:lightbulb-group";
        };
        "light.0x60b647fffeb0862b" = {
          friendly_name = "Office light";
          icon = "mdi:ceiling-light";
        };
        "light.0x84b4dbfffe67f444" = {
          friendly_name = "Worktop light";
          icon = "mdi:led-strip-variant";
        };
        "light.0x5cc7c1fffe69963c" = {
          friendly_name = "Spot #0";
          icon = "mdi:lightbulb-spot";
        };
        "light.0x5cc7c1fffe2de077" = {
          friendly_name = "Spot #1";
          icon = "mdi:lightbulb-spot";
        };
        "light.0x287681fffe46dbae" = {
          friendly_name = "Spot #2";
          icon = "mdi:lightbulb-spot";
        };
        "light.0x287681fffe09a632" = {
          friendly_name = "Spot #3";
          icon = "mdi:lightbulb-spot";
        };
        "light.0x287681fffe8fff12" = {
          friendly_name = "Spot #4";
          icon = "mdi:lightbulb-spot";
        };
        "light.0x5cc7c1fffe2e2709" = {
          friendly_name = "Spot #5";
          icon = "mdi:lightbulb-spot";
        };
        "light.0x5cc7c1fffeeeff1e" = {
          friendly_name = "Spot #6";
          icon = "mdi:lightbulb-spot";
        };
        "light.0xf082c0fffe40ceda" = {
          friendly_name = "Spot #7";
          icon = "mdi:lightbulb-spot";
        };
        "light.0x5cc7c1fffe16cd17" = {
          friendly_name = "Spot #8";
          icon = "mdi:lightbulb-spot";
        };
        "light.0x287681fffe4382f4" = {
          friendly_name = "Spot #9";
          icon = "mdi:lightbulb-spot";
        };

        "sensor.0x70b3d52b601329c7_energy".friendly_name = "Office energy";
        "sensor.0x70b3d52b601329c7_power".friendly_name = "Office power";
        "switch.0x70b3d52b601329c7".device_class = "outlet";
        "switch.0x70b3d52b601329c7".icon = "mdi:power-socket-eu";
        "switch.0x70b3d52b601329c7".friendly_name = "Office main socket";

        "sensor.0x08b95ffffec66e5d_energy".friendly_name = "Dishwasher energy";
        "sensor.0x08b95ffffec66e5d_power".friendly_name = "Dishwasher power";
        "sensor.0x08b95ffffec66e5d_power".icon = "mdi:dishwasher";
        "switch.0x08b95ffffec66e5d".device_class = "outlet";
        "switch.0x08b95ffffec66e5d".icon = "mdi:power-socket-eu";
        "switch.0x08b95ffffec66e5d".friendly_name = "Dishwasher socket";

        "sensor.0x70b3d52b601352e1_energy".friendly_name = "Washer energy";
        "sensor.0x70b3d52b601352e1_power".friendly_name = "Washer power";
        "sensor.0x70b3d52b601352e1_power".icon = "mdi:washing-machine";
        "switch.0x70b3d52b601352e1".device_class = "outlet";
        "switch.0x70b3d52b601352e1".icon = "mdi:power-socket-eu";
        "switch.0x70b3d52b601352e1".friendly_name = "Washer socket";

        "sensor.0x70b3d52b60135977_energy".friendly_name = "Dryer energy";
        "sensor.0x70b3d52b60135977_power".friendly_name = "Dryer power";
        "sensor.0x70b3d52b60135977_power".icon = "mdi:tumble-dryer";
        "switch.0x70b3d52b60135977".device_class = "outlet";
        "switch.0x70b3d52b60135977".icon = "mdi:power-socket-eu";
        "switch.0x70b3d52b60135977".friendly_name = "Dryer socket";

        "sensor.0x70b3d52b60132af9_energy".friendly_name = "Rack energy";
        "sensor.0x70b3d52b60132af9_power".friendly_name = "Rack power";
        "sensor.0x70b3d52b60132af9_power".icon = "mdi:server-network";
        "sensor.0x70b3d52b60132af9".device_class = "outlet";
        "sensor.0x70b3d52b60132af9".icon = "mdi:power-socket-eu";
        "sensor.0x70b3d52b60132af9".friendly_name = "Rack socket";
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
  };
  # hack to fix yaml functions
  configuration = pkgs.runCommand "configuration.yaml" { preferLocalBuild = true; } ''
    cp ${config} $out
    sed -i -e "s/'\!\([a-z_]\+\) \(.*\)'/\!\1 \2/;s/^\!\!/\!/;" $out
  '';
in
{

  services.influxdb2.enable = true;

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
        image = "ghcr.io/home-assistant/home-assistant:2025.8.2";
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
