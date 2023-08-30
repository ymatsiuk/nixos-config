{ pkgs, ... }:
let
  checkNixosUpdates = pkgs.writeShellScript "checkUpdates.sh" ''
    UPDATE='{"icon":"upd","state":"Info", "text": ""}'
    NO_UPDATE='{"icon":"noupd","state":"Good", "text": ""}'
    GITHUB_URL="https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/nixos-unstable"
    CURRENT_REVISION=$(nixos-version --revision)
    REMOTE_REVISION=$(curl -s $GITHUB_URL | jq '.object.sha' -r )
    [ $CURRENT_REVISION == $REMOTE_REVISION ] && echo $NO_UPDATE || echo $UPDATE
  '';
  kernel = pkgs.writeShellScript "uname.sh" ''
    echo '{"icon": "tux", "text": "'$(uname -r)'"}'
  '';
  secrets = import ../secrets.nix;
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          { block = "custom"; command = kernel; json = true; interval = "once"; }
          { block = "net"; missing_format = ""; device = "^sk0$"; format = "$icon "; icons_format = ""; } # "\ue4a5"
          { block = "net"; missing_format = ""; device = "^nu0$"; format = "$icon "; icons_format = ""; } # "\ue4d6"
          { block = "custom"; command = checkNixosUpdates; json = true; interval = 300; }
          { block = "uptime"; }
          { block = "bluetooth"; mac = "CC:98:8B:93:08:1F"; disconnected_format = ""; format = " $icon { $percentage|} "; }
          { block = "bluetooth"; mac = "18:B9:6E:D8:41:A9"; disconnected_format = ""; format = " $icon { $percentage|} "; }
          { block = "cpu"; }
          { block = "net"; device = "wlan0"; format = " $icon $signal_strength "; }
          { block = "weather"; service = { name = "openweathermap"; city_id = secrets.i3status-rust.cityId; api_key = secrets.i3status-rust.openWeatherApiKey; }; }
          { block = "backlight"; }
          { block = "temperature"; }
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
