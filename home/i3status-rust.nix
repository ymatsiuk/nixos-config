{ pkgs, ... }:
let
  swayOutputIsActive = pkgs.writeShellScript "swayOutputIsActive.sh" ''
    ${pkgs.sway}/bin/swaymsg -t get_outputs | ${pkgs.jq}/bin/jq -rc '.[] | select(.name | contains("'$1'")) | select(.active == true)'
  '';
  a2dpIsActive = pkgs.writeShellScript "a2dpIsActive.sh" ''
    ${pkgs.pulseaudio}/bin/pactl list sinks short | ${pkgs.gnugrep}/bin/egrep -o "bluez_output[[:alnum:]._]+.a2dp-sink"
  '';
  bluezCard = pkgs.writeShellScript "bluezCard.sh" ''
    ${pkgs.pulseaudio}/bin/pactl list cards short | ${pkgs.gnugrep}/bin/egrep -o "bluez_card[[:alnum:]._]+"
  '';
  setProfile = pkgs.writeShellScript "setProfile.sh" ''
    ${pkgs.pulseaudio}/bin/pactl set-card-profile $(${bluezCard}) $1
  '';

  # FOMO: detect if there is a newer kernel version available:
  # fetch latest available kernel version from kernel.org and compare it against local version
  upstream = "${pkgs.curl}/bin/curl -Ls https://www.kernel.org | ${pkgs.pup}/bin/pup 'table[id=releases] tr:first-child strong text{}' | ${pkgs.coreutils}/bin/tr -d '[:space:]'";
  local = "KERN=$(${pkgs.coreutils}/bin/uname -r | sed 's/\.0-/-/') && [[ \${KERN: -1} == 0 ]] && echo \${KERN%.*} || echo \${KERN}";
  noNewKernelMessage = "'{\"icon\":\"tux\", \"text\":\"'$(${pkgs.coreutils}/bin/uname -r)'\"}'";
  newKernelMessage = "'{\"icon\":\"tux\", \"text\":\"'$(${pkgs.coreutils}/bin/uname -r)'\", \"state\": \"Info\"}'";
in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        blocks = [
          {
            block = "custom";
            command = "[[ $(${local}) == $(${upstream}) ]] && echo ${noNewKernelMessage} || echo ${newKernelMessage}";
            interval = 600;
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
            block = "toggle";
            text = "DP-6";
            command_state = "${swayOutputIsActive} DP-6";
            command_on = "${pkgs.sway}/bin/swaymsg output DP-6 enable";
            command_off = "${pkgs.sway}/bin/swaymsg output DP-6 disable";
          }
          {
            block = "toggle";
            text = "DP-5";
            command_state = "${swayOutputIsActive} DP-5";
            command_on = "${pkgs.sway}/bin/swaymsg output DP-5 enable";
            command_off = "${pkgs.sway}/bin/swaymsg output DP-5 disable";
          }
          {
            block = "bluetooth";
            mac = "CC:98:8B:93:08:1F";
            label = " WH-1000XM3";
          }
          {
            block = "toggle";
            text = "A2DP/HSP";
            command_state = "${a2dpIsActive}";
            command_on = "${setProfile} a2dp-sink-aptx_hd";
            command_off = "${setProfile} headset-head-unit-cvsd";
            interval = 5;
          }
          { block = "cpu"; format = "{utilization} {frequency}"; }
          { block = "net"; format = "{signal_strength}"; }
          { block = "backlight"; }
          { block = "temperature"; collapsed = false; }
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
