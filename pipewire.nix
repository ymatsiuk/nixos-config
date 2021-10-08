{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    media-session.config.bluez-monitor = {
      properties = { };
      rules = [
        {
          matches = [{ device.name = "~bluez_card.*"; }];
          actions.update-props.bluez5.autoswitch-profile = true;
          actions.update-props.bluez5.auto-connect = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
        }
        {
          matches = [{ node.name = "~bluez_input.*"; } { node.name = "~bluez_output.*"; }];
          actions.update-props.node.pause-on-idle = false;
        }
      ];
    };
  };
}
