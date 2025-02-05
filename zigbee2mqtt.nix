{
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      advanced = {
        channel = 25;
        device_options.legacy = false;
        homeassistant_legacy_entity_attributes = false;
        homeassistant_legacy_triggers = false;
        legacy_api = false;
        legacy_availability_payload = false;
        last_seen = "ISO_8601";
        transmit_power = 20;
      };
      availability.enabled = true;
      devices = "devices.yaml";
      frontend.enabled = true;
      groups = "groups.yaml";
      homeassistant.enabled = true;
      mqtt = {
        base_topic = "zigbee2mqtt";
        server = "mqtt://nixpi4:1883";
      };
      permit_join = false;
      serial = {
        adapter = "ember";
        baudrate = 115200;
        port = "tcp://slzb-06m.local:6638";
      };
      version = 4;
    };
  };
}
