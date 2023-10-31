let
  secrets = import ../secrets.nix;
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          { block = "pomodoro"; }
          { block = "net"; missing_format = ""; device = "^sk0$"; format = " $icon "; icons_format = ""; } # "\ue4a5"
          { block = "net"; missing_format = ""; device = "^nu0$"; format = " $icon "; icons_format = ""; } # "\ue4d6"
          { block = "bluetooth"; mac = "CC:98:8B:93:08:1F"; disconnected_format = ""; format = " $icon { $percentage|} "; }
          { block = "bluetooth"; mac = "18:B9:6E:D8:41:A9"; disconnected_format = ""; format = " $icon { $percentage|} "; }
          { block = "net"; device = "wlan0"; format = " $icon $ssid $signal_strength "; }
          { block = "weather"; service = { name = "openweathermap"; city_id = secrets.i3status-rust.cityId; api_key = secrets.i3status-rust.openWeatherApiKey; }; }
          { block = "sound"; driver = "pulseaudio"; click = [{ button = "left"; cmd = "pavucontrol"; }]; }
          { block = "battery"; driver = "upower"; device = "BAT0"; }
          { block = "time"; format = " $icon $timestamp.datetime(f:'%a %e %b %R', l:nl_NL) "; click = [{ button = "left"; cmd = "gsimplecal"; }]; }
        ];
        settings = {
          theme = {
            theme = "gruvbox-dark";
            overrides = {
              idle_bg = "#3c3836";
              separator = "<span font='12'></span>";
            };
          };
          icons = {
            icons = "awesome6";
            overrides = {
              tux = ""; # "\uf17c"
              upd = ""; # "\uf055"
              noupd = ""; # "\uf056"
            };
          };
        };
      };
    };
  };
}
