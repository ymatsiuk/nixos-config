{ pkgs, ... }:
let
  a2dpIsActive = pkgs.writeShellScript "a2dpIsActive.sh" ''
    pactl list sinks short | egrep -o "bluez_output[[:alnum:]._]+.a2dp-sink"
  '';
  bluezCard = pkgs.writeShellScript "bluezCard.sh" ''
    pactl list cards short | egrep -o "bluez_card[[:alnum:]._]+"
  '';
  setProfile = pkgs.writeShellScript "setProfile.sh" ''
    pactl set-card-profile $(${bluezCard}) $1
  '';
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
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          { block = "custom"; command = kernel; json = true; interval = "once"; }
          { block = "custom"; command = checkNixosUpdates; json = true; interval = 300; }
          { block = "uptime"; }
          { block = "bluetooth"; mac = "CC:98:8B:93:08:1F"; }
          {
            block = "toggle";
            text = "A2DP/HSP";
            command_state = "${a2dpIsActive}";
            command_on = "${setProfile} a2dp-sink-aptx_hd";
            command_off = "${setProfile} headset-head-unit";
            interval = 5;
          }
          { block = "cpu"; format = "{utilization} {frequency}"; }
          { block = "net"; format = "{signal_strength}: {speed_up;K} {speed_down;K}"; }
          { block = "backlight"; }
          { block = "temperature"; driver = "sysfs"; collapsed = false; format = "{average}"; }
          { block = "sound"; driver = "pulseaudio"; on_click = "pavucontrol"; }
          { block = "battery"; driver = "upower"; device = "DisplayDevice"; }
          { block = "time"; on_click = "gsimplecal"; }
        ];
        settings = {
          theme = {
            name = "gruvbox-dark";
            overrides = {
              idle_bg = "#3c3836";
            };
          };
          icons = {
            name = "awesome";
            overrides = {
              tux = "";
              upd = "";
              noupd = "";
            };
          };
        };
        icons = "awesome";
        theme = "gruvbox-dark";
      };
    };
  };
}
