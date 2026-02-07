{ pkgs, ... }:
let
  secrets = import ./secrets.nix;
  yaml = pkgs.formats.yaml { };
in
{
  virtualisation.oci-containers.containers = {
    # Z2M for Deconz USB stick
    zigbee2mqtt_deconz = {
      dependsOn = [ "mosquitto" ];
      image = "ghcr.io/koenkk/zigbee2mqtt:2.8.0";
      environment.TZ = "Europe/Amsterdam";
      podman = {
        sdnotify = "healthy";
        user = "ymatsiuk";
      };
      volumes =
        let
          deconz = yaml.generate "deconz.yaml" {
            frontend = {
              enabled = true;
              port = 8080;
            };
            mqtt = {
              base_topic = "zigbee2mqtt_deconz";
              server = "mqtt://nixlab.local:1883";
              version = 5;
            };
            permit_join = false;
            homeassistant = {
              enabled = true;
              experimental_event_entities = true;
            };
            serial = {
              port = "/dev/ttyACM0";
              adapter = "deconz";
              baudrate = 115200;
              rtscts = false;
            };
            version = 5;
            advanced = {
              log_level = "debug";
              channel = 25;
              last_seen = "ISO_8601";
              network_key = secrets.zigbee2mqtt.deconz.network_key;
              pan_id = secrets.zigbee2mqtt.deconz.pan_id;
              ext_pan_id = secrets.zigbee2mqtt.deconz.ext_pan_id;
            };
            devices = "devices.yaml";
            groups = "groups.yaml";
            availability = {
              enabled = true;
            };
          };
        in
        [
          "/run/dbus:/run/dbus:ro"
          "/home/ymatsiuk/zigbee2mqtt/deconz:/app/data"
          "${deconz}:/app/data/configuration.yaml:ro"
        ];
      ports = [ "9090:8080" ];
      devices = [
        "/dev/serial/by-id/usb-dresden_elektronik_ingenieurtechnik_GmbH_ConBee_II_DE2598392-if00:/dev/ttyACM0"
      ];
      extraOptions = [
        "--cap-drop=ALL"
        "--userns=keep-id"
        "--group-add=keep-groups"
        "--health-cmd"
        "wget -qO /dev/null http://localhost:8080 || exit 1"
      ];
    };
    # Z2M for SLZB-06M
    zigbee2mqtt_slzb06m = {
      dependsOn = [ "mosquitto" ];
      image = "ghcr.io/koenkk/zigbee2mqtt:2.8.0";
      environment.TZ = "Europe/Amsterdam";
      podman = {
        sdnotify = "healthy";
        user = "ymatsiuk";
      };
      volumes =
        let
          slzb06m = yaml.generate "slzb06m.yaml" {
            advanced = {
              log_level = "debug";
              channel = 25;
              last_seen = "ISO_8601";
              transmit_power = 20;
              network_key = secrets.zigbee2mqtt.slzb06m.network_key;
              pan_id = secrets.zigbee2mqtt.slzb06m.pan_id;
              ext_pan_id = secrets.zigbee2mqtt.slzb06m.ext_pan_id;
            };
            availability.enabled = true;
            frontend.enabled = true;
            homeassistant = {
              enabled = true;
              experimental_event_entities = true;
            };
            mqtt = {
              base_topic = "zigbee2mqtt_slzb06m";
              server = "mqtt://nixlab.local:1883";
              version = 5;
            };
            serial = {
              adapter = "ember";
              baudrate = 115200;
              port = "tcp://slzb-06m.lan:6638";
            };
            version = 5;
            devices = "devices.yaml";
            groups = "groups.yaml";
          };
        in
        [
          "/run/dbus:/run/dbus:ro"
          "/home/ymatsiuk/zigbee2mqtt/slzb06m:/app/data"
          "${slzb06m}:/app/data/configuration.yaml:ro"
        ];
      ports = [ "8090:8080" ];
      extraOptions = [
        "--cap-drop=ALL"
        "--userns=keep-id"
        "--group-add=keep-groups"
        "--health-cmd"
        "wget -qO /dev/null http://localhost:8080 || exit 1"
      ];
    };
    # Mosquitto
    mosquitto = {
      image = "docker.io/eclipse-mosquitto:2.0.22"; # itho doesn't support 2.1.x yet
      podman = {
        sdnotify = "healthy";
        user = "ymatsiuk";
      };
      extraOptions = [
        "--cap-drop=ALL"
        "--userns=keep-id"
        "--health-cmd"
        "mosquitto_sub -t '$SYS/#' -C 1 -i healthcheck -W 3 || exit 1" # https://github.com/eclipse-mosquitto/mosquitto/issues/1270#issuecomment-1478648748
      ];
      ports = [
        "1883:1883/tcp"
      ];
      volumes =
        let
          config = pkgs.writeText "mosquitto.conf" ''
            listener 1883
            allow_anonymous true
          '';
        in
        [
          "${config}:/mosquitto/config/mosquitto.conf:ro"
          "/home/ymatsiuk/mosquitto:/mosquitto"
        ];
    };
  };
}
