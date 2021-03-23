{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
          blocks = [
            {
              block = "bluetooth"; mac = "CC:98:8B:93:08:1F"; label = " WH-1000XM3"; }
            {
              block = "toggle";
              text = "A2DP/HSP";
              command_state = "pactl list sinks short | egrep -o \"bluez_output[[:alnum:]._]+.a2dp-sink\"";
              command_on = "pactl set-card-profile $(pactl list cards short | egrep -o \"bluez_card[[:alnum:]._]+\") a2dp-sink-aptx_hd";
              command_off = "pactl set-card-profile $(pactl list cards short | egrep -o \"bluez_card[[:alnum:]._]+\") headset-head-unit";
              interval = 5;
            }
            {
              block = "custom";
              command = "echo '{\"icon\":\"tux\", \"text\": \"'$(uname -r)'\"}'";
              interval = "once";
              json = true;
            }
            {
              block = "custom";
              command = "[ $(cut -c 16- /nix/var/nix/gcroots/current-system/nixos-version) != $(curl -s -m 0.5 https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/nixos-unstable | jq '.object.sha' -r | cut -c 1-11) ] && echo '{\"icon\":\"upd\",\"state\":\"Info\", \"text\": \"Yes\"}' || echo '{\"icon\":\"noupd\",\"state\":\"Good\", \"text\": \"No\"}'";
              interval = 300;
              json = true;
            }
            { block = "uptime"; }
            { block = "cpu"; format = "{utilization} {frequency}"; }
            { block = "net"; device = "wlp0s20f3"; ssid = true ; signal_strength = true; }
            { block = "backlight"; }
            { block = "temperature"; collapsed = false; }
            { block = "sound"; driver = "pulseaudio"; on_click = "pavucontrol"; }
            { block = "battery"; driver = "upower"; }
            { block = "time"; on_click = "gsimplecal"; }
          ];
          settings = {
            theme =  {
              name = "gruvbox-dark";
              overrides = {
                idle_bg = "#3c3836";
              };
            };
            icons =  {
              name = "awesome5";
              overrides = {
                tux = "  ";
                upd = "  ";
                noupd = "  ";
                volume_muted = "  ";
              };
            };
          };
        icons = "awesome5";
        theme = "gruvbox-dark";
      };
    };
  };
}
