{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    media-session.config.bluez-monitor = {
      rules = [
        {
          matches = [
            { device.name = "~bluez_card.*"; }
          ];
          actions.update-props.bluez5.auto-connect = [
            "hfp_hf"
            "hsp_hs"
            "a2dp_sink"
            "a2dp_source"
          ];
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
