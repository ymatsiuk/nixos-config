{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    media-session.config.bluez-monitor = {
      properties = {
        bluez5.enable-msbc = true;
        bluez5.headset-roles = [
          "hsp_hs"
          "hfp_ag"
        ];
      };
      rules = [
        {
          matches = [
            { device.name = "~bluez_card.*"; }
          ];
          actions.update-props.bluez5 = {
            msbc-support = true;
            auto-connect = [
              "hsp_hs"
              "hfp_ag"
              "a2dp_sink"
              "a2dp_source"
            ];
          };
        }
        {
          matches = [
            { node.name = "~bluez_input.*"; }
            { node.name = "~bluez_output.*"; }
          ];
          actions.update-props.node.pause-on-idle = false;
        }
      ];
    };
  };
}
