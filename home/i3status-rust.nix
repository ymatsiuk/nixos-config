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
  sit = pkgs.writeShellScript "sit.sh" ''
    ${pkgs.idasen-cli}/bin/idasen-cli restore sit 2>&1>/dev/null &
    echo '{"icon":"sit","state":"Info","text":"sit"}'
  '';
  stand = pkgs.writeShellScript "stand.sh" ''
    ${pkgs.idasen-cli}/bin/idasen-cli restore stand 2>&1>/dev/null &
    echo '{"icon":"stand","state":"Info","text":"stand"}'
  '';
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          { block = "custom"; command = kernel; json = true; interval = "once"; }
          { block = "net"; hide_missing = true; hide_inactive = true; device = "tun0"; format = " "; }
          { block = "custom"; command = checkNixosUpdates; json = true; interval = 300; }
          { block = "uptime"; }
          { block = "bluetooth"; mac = "CC:98:8B:93:08:1F"; hide_disconnected = true; format = "$percentage|"; }
          { block = "bluetooth"; mac = "18:B9:6E:D8:41:A9"; hide_disconnected = true; format = "$percentage|"; }
          { block = "cpu"; }
          { block = "net"; device = "wlan0"; format = "$signal_strength"; }
          { block = "backlight"; }
          { block = "temperature"; collapsed = false; }
          { block = "sound"; driver = "pulseaudio"; click = [{ button = "left"; cmd = "pavucontrol"; }]; }
          { block = "battery"; driver = "upower"; device = "BAT0"; }
          { block = "time"; locale = "nl_NL"; format = "%a %e %b %R"; click = [{ button = "left"; cmd = "gsimplecal"; }]; }
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
              tux = "";
              upd = "";
              noupd = "";
              sit = "";
              stand = "";
            };
          };
        };
      };
    };
  };
}
