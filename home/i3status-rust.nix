{ pkgs, ... }:
let
  a2dpIsActive = pkgs.writeShellScript "a2dpIsActive.sh" ''
    ${pkgs.pulseaudio}/bin/pactl list sinks short | ${pkgs.gnugrep}/bin/egrep -o "bluez_output[[:alnum:]._]+.a2dp-sink"
  '';
  bluezCard = pkgs.writeShellScript "bluezCard.sh" ''
    ${pkgs.pulseaudio}/bin/pactl list cards short | ${pkgs.gnugrep}/bin/egrep -o "bluez_card[[:alnum:]._]+"
  '';
  setProfile = pkgs.writeShellScript "setProfile.sh" ''
    ${pkgs.pulseaudio}/bin/pactl set-card-profile $(${bluezCard}) $1
  '';
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          {
            block = "custom";
            command = "echo '{\"icon\": \"tux\", \"text\": \"'$(${pkgs.coreutils}/bin/uname -r)'\"}'";
            interval = "once";
            json = true;
          }
          { block = "uptime"; }
          {
            block = "custom";
            command = "[ $(nixos-version --revision) != $(curl -s -m 0.5 https://api.github.com/repos/NixOS/nixpkgs/git/refs/heads/nixos-unstable | jq '.object.sha' -r ) ] && echo '{\"icon\":\"upd\",\"state\":\"Info\", \"text\": \"Yes\"}' || echo '{\"icon\":\"noupd\",\"state\":\"Good\", \"text\": \"No\"}'";
            interval = 300;
            json = true;
          }
          {
            block = "bluetooth";
            mac = "CC:98:8B:93:08:1F";
          }
          {
            block = "toggle";
            text = "A2DP/HSP";
            command_state = "${a2dpIsActive}";
            command_on = "${setProfile} a2dp-sink-aptx_hd";
            command_off = "${setProfile} headset-head-unit";
            interval = 5;
          }
          { block = "cpu"; format = "{utilization} {frequency}"; }
          { block = "net"; format = "{signal_strength}"; }
          { block = "backlight"; }
          { block = "temperature"; driver = "sysfs"; collapsed = false; format = "{average}"; }
          { block = "sound"; driver = "pulseaudio"; on_click = "${pkgs.pavucontrol}/bin/pavucontrol"; }
          { block = "battery"; driver = "upower"; }
          { block = "time"; on_click = "${pkgs.gsimplecal}/bin/gsimplecal"; }
        ];
        settings = {
          theme = {
            name = "gruvbox-dark";
            overrides = {
              idle_bg = "#3c3836";
            };
          };
          icons = {
            name = "awesome5";
            overrides = {
              tux = "";
              upd = "";
              noupd = "";
              volume_muted = "";
            };
          };
        };
        icons = "awesome5";
        theme = "gruvbox-dark";
      };
    };
  };
}
