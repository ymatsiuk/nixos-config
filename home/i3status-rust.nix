{ pkgs, ... }:
let
  a2dpIsActive = pkgs.writeShellScript "a2dpIsActive.sh" ''
    pw-metadata | egrep "default.audio.sink.*.bluez_output.CC_98_8B_93_08_1F.a2dp-sink"
  '';
  setProfile = pkgs.writeShellScript "setProfile.sh" ''
    # pw-cli enum-params bluez_card.CC_98_8B_93_08_1F EnumProfile
    # 260 -> headset-head-unit-msbc, 10 -> a2dp-sink-ldac
    pw-cli s bluez_card.CC_98_8B_93_08_1F Profile "{ index: $1 }"
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
            text = "ldac";
            command_state = "${a2dpIsActive}";
            command_on = "${setProfile} 10";
            command_off = "${setProfile} 260";
            interval = 5;
          }
          { block = "cpu"; format = "{utilization} {frequency}"; }
          { block = "net"; format = "{signal_strength}: {speed_up;K} {speed_down;K}"; }
          { block = "backlight"; }
          { block = "temperature"; collapsed = false; format = "{average}"; }
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
