let
  secrets = import ../secrets.nix;
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          {
            block = "weather";
            service = {
              name = "openweathermap";
              city_id = secrets.i3status-rust.cityId;
              api_key = secrets.i3status-rust.openWeatherApiKey;
            };
          }
          {
            block = "battery";
            driver = "upower";
            device = "BAT0";
          }
          {
            block = "time";
            format = " $icon $timestamp.datetime(f:'%a %e %b %R', l:nl_NL) ";
            click = [
              {
                button = "left";
                cmd = "gsimplecal";
              }
            ];
          }
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
          };
        };
      };
    };
  };
}
