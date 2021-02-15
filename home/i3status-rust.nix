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
               block = "custom";
               # check if local lags behind nixos-unstable
               command = "[ $(cut -c 16- /nix/var/nix/gcroots/current-system/nixos-version) != $(curl -s -m 0.5 https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/nixos-unstable | jq '.object.sha' -r | cut -c 1-11) ] && echo '{\"icon\":\"upd\",\"state\":\"Info\", \"text\": \"Yes\"}' || echo '{\"icon\":\"noupd\",\"state\":\"Good\", \"text\": \"No\"}'";
               # on_click = "pkill -SIGRTMIN+0 i3status-rs";
               # signal = 0;
               interval = 300;
               json = true;
             }
             {
               block = "uptime";
               interval = 300;
             }
             {
               block = "cpu";
               interval = 1;
               format = "{utilization} {frequency}";
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
             {
               block = "sound";
               show_volume_when_muted = true;
             }
             {
               block = "battery";
               driver = "upower";
               format = "{percentage}% {time}";
             }
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
                tux = "  ";
                upd = "  ";
                noupd = "  ";
              };
            };
          };
        icons = "awesome5";
        theme = "gruvbox-dark";
      };
    };
  };
}
