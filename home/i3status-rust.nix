{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
          blocks = [
             {
               block = "custom";
               command = "echo '{\"icon\":\"tux\", \"text\": \"'$(uname -r)'\"}'";
               interval = "once";
               json = true;
             }
             {
               block = "cpu";
               interval = 1;
               format = "{utilization}% {frequency}GHz";
             }
             {
               block = "load";
               interval = 1;
               format = "{1m}";
             }
             {
               block = "net";
               device = "wlp2s0";
               ssid = true ;
               signal_strength = true;
             }
             { block = "backlight"; }
             {
               block = "temperature";
               collapsed = false;
             }
             # { block = "hueshift"; }
             {
               block = "sound";
               show_volume_when_muted = true;
             }
             {
               block = "battery";
               format = "{percentage}% {time}"; }
             {
               block = "time";
               interval = 60;
               format = "%a %d/%m %R";
               on_click = "gsimplecal";
             }
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
                tux = " ";
              };
            };
          };
        icons = "awesome5";
        theme = "gruvbox-dark";
      };
    };
  };
}
