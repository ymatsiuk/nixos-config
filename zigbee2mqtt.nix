{ pkgs, ... }:
{
  virtualisation.oci-containers.containers = {
    # Z2M for Deconz USB stick
    zigbee2mqtt_deconz = {
      dependsOn = [ "mosquitto" ];
      image = "ghcr.io/koenkk/zigbee2mqtt:2.7.2";
      environment.TZ = "Europe/Amsterdam";
      podman = {
        sdnotify = "healthy";
        user = "ymatsiuk";
      };
      volumes = [
        "/run/dbus:/run/dbus:ro"
        "/home/ymatsiuk/zigbee2mqtt/deconz:/app/data"
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
      image = "ghcr.io/koenkk/zigbee2mqtt:2.7.2";
      environment.TZ = "Europe/Amsterdam";
      podman = {
        sdnotify = "healthy";
        user = "ymatsiuk";
      };
      volumes = [
        "/run/dbus:/run/dbus:ro"
        "/home/ymatsiuk/zigbee2mqtt/slzb06m:/app/data"
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
