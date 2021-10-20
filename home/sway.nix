{ pkgs, lib, config, ... }:

let
  lockCmd = "${pkgs.swaylock-effects}/bin/swaylock --daemonize --screenshots --indicator --effect-pixel 10";
  idleCmd = ''${pkgs.swayidle}/bin/swayidle -w \
    timeout 300 "${lockCmd}" \
    timeout 600 "swaymsg 'output * dpms off'" \
    resume "swaymsg 'output * dpms on'" \
    before-sleep "${lockCmd}"'';
  gsettings = "${pkgs.glib}/bin/gsettings";
  gtkSettings = import ./gtk.nix { inherit pkgs; };
  gnomeSchema = "org.gnome.desktop.interface";
  systemdRun = { pkg, bin ? pkg.pname, args ? "" }: ''
    ${pkgs.systemd}/bin/systemd-run --user --scope --collect --quiet \
    --unit=${bin}-$(${pkgs.systemd}/bin/systemd-id128 new) \
    ${pkgs.systemd}/bin/systemd-cat --identifier=${bin} \
    ${lib.makeBinPath [ pkg ]}/${bin} ${args}
  '';
  importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
    ${gsettings} set ${gnomeSchema} gtk-theme ${gtkSettings.gtk.theme.name}
    ${gsettings} set ${gnomeSchema} icon-theme ${gtkSettings.gtk.iconTheme.name}
    ${gsettings} set ${gnomeSchema} cursor-theme ${gtkSettings.gtk.gtk3.extraConfig.gtk-cursor-theme-name}
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemdIntegration = true;
    config = {
      gaps = {
        smartBorders = "on";
      };
      fonts = {
        names = [ "Iosevka" ];
      };
      modifier = "Mod4";
      menu = "${pkgs.dmenu-wayland}/bin/dmenu-wl_run -i";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+Shift+e" = "exit";
          "${mod}+Shift+a" = "exec ${systemdRun { pkg = pkgs.appgate-sdp; bin = "appgate";} }";
          "${mod}+Shift+b" = "exec ${systemdRun { pkg = pkgs.bluejeans-gui; } }";
          "${mod}+Shift+f" = "exec ${systemdRun { pkg = pkgs.firefox; bin = "firefox"; } }";
          "${mod}+Shift+s" = "exec ${systemdRun { pkg = pkgs.slack; args = "--logLevel=error";} }";
          "${mod}+Shift+z" = "exec ${systemdRun { pkg = pkgs.zoom; bin = "zoom";} }";
          "XF86AudioPlay" = "exec ${systemdRun { pkg = pkgs.playerctl; args = "play-pause";} }";
          "XF86AudioNext" = "exec ${systemdRun { pkg = pkgs.playerctl; args = "next";} }";
          "XF86AudioPrev" = "exec ${systemdRun { pkg = pkgs.playerctl; args = "previous";} }";
          "XF86AudioRaiseVolume" = "exec ${systemdRun { pkg = pkgs.pulseaudioFull; bin = "pactl"; args = "set-sink-volume @DEFAULT_SINK@ +5%";} }";
          "XF86AudioLowerVolume" = "exec ${systemdRun { pkg = pkgs.pulseaudioFull; bin = "pactl"; args = "set-sink-volume @DEFAULT_SINK@ -5%";} }";
          "XF86AudioMute" = "exec ${systemdRun { pkg = pkgs.pulseaudioFull; bin = "pactl"; args = "set-sink-mute @DEFAULT_SINK@ toggle";} }";
          "XF86MonBrightnessDown" = "exec ${systemdRun { pkg = pkgs.light; args = "-U 5%";} }";
          "XF86MonBrightnessUp" = "exec ${systemdRun { pkg = pkgs.light; args = "-A 5%";} }";
          "--release Print" = "exec ${systemdRun { pkg = pkgs.sway-contrib.grimshot; args = "--notify save area ~/scr/scr_`date +%Y%m%d.%H.%M.%S`.png";} }";
          "--release ${mod}+Print" = "exec ${systemdRun { pkg = pkgs.sway-contrib.grimshot; args = "--notify save output ~/scr/scr_`date +%Y%m%d.%H.%M.%S`.png";} }";
        };
      colors = {
        focused = {
          background = "#b16286";
          border = "#b16286";
          childBorder = "#b16286";
          indicator = "#b16286";
          text = "#ebdbb2";
        };
        focusedInactive = {
          background = "#689d6a";
          border = "#689d6a";
          childBorder = "#689d6a";
          indicator = "#689d6a";
          text = "#ebdbb2";
        };
        unfocused = {
          background = "#3c3836";
          border = "#3c3836";
          childBorder = "#3c3836";
          indicator = "#3c3836";
          text = "#ebdbb2";
        };
        urgent = {
          background = "#cc241d";
          border = "#cc241d";
          childBorder = "#cc241d";
          indicator = "#cc241d";
          text = "#ebdbb2";
        };
        placeholder = {
          background = "#000000";
          border = "#000000";
          childBorder = "#000000";
          indicator = "#000000";
          text = "#ebdbb2 ";
        };
      };
      bars = [
        {
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
          fonts = {
            names = [ "Iosevka" ];
            size = 10.0;
          };
          position = "bottom";
          colors = {
            background = "#3c3836";
            separator = "#666666";
            statusline = "#ebdbb2";
            activeWorkspace = {
              border = "#689d6a";
              background = "#689d6a";
              text = "#ebdbb2";
            };
            focusedWorkspace = {
              border = "#b16286";
              background = "#b16286";
              text = "#ebdbb2";
            };
            inactiveWorkspace = {
              border = "#3c3836";
              background = "#3c3836";
              text = "#ebdbb2";
            };
            urgentWorkspace = {
              border = "#cc241d";
              background = "#cc241d";
              text = "#ebdbb2";
            };
          };
        }
      ];
      input = {
        "type:keyboard" = {
          repeat_delay = "300";
          repeat_rate = "20";
        };
        "type:touchpad" = {
          dwt = "enabled";
          middle_emulation = "enabled";
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };
      window = {
        titlebar = false;
        hideEdgeBorders = "smart";
        commands = [
          { command = "floating enable"; criteria = { app_id = "gsimplecal"; }; }
          { command = "floating enable"; criteria = { app_id = "mpv"; }; }
          { command = "move container to workspace 2"; criteria = { app_id = "^(?i)slack$"; }; }
          { command = "move container to workspace 3"; criteria = { app_id = "^(?i)firefox$"; }; }
          { command = "floating enable, move scratchpad"; criteria = { class = "Appgate SDP"; }; }
          { command = "floating enable, resize set width 600px height 800px"; criteria = { title = "Save File"; }; }
          # browser screen sharing
          { command = "inhibit_idle visible, floating enable"; criteria = { title = "(is sharing your screen)|(Sharing Indicator)|(Slack call)"; }; }
          # browser zoom|meet|bluejeans
          { command = "inhibit_idle visible"; criteria = { title = "(Blue Jeans Network)|(Meet)|(Zoom Meeting)"; }; }
          # meeting apps
          { command = "floating enable, inhibit_idle visible, move container to workspace 5"; criteria = { title = "((?i)zoom(.*))|(^Settings$)"; }; }
          { command = "floating enable, inhibit_idle visible, move container to workspace 5"; criteria = { class = "bluejeans-v2"; }; }
        ];
      };
      startup = [
        { command = "${idleCmd}"; }
        { command = "${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY DBUS_SESSION_BUS_ADDRESS SWAYSOCK XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP"; } #workaround
        { command = "${importGsettings}"; always = true; }
        { command = "${pkgs.alacritty}/bin/alacritty"; }
        { command = "${systemdRun { pkg = pkgs.appgate-sdp; bin = "appgate";} }"; }
        { command = "${systemdRun { pkg = pkgs.firefox; bin = "firefox";} }"; }
        { command = "${systemdRun { pkg = pkgs.slack; args = "--logLevel=error";} }"; }
      ];
    };
    extraConfig = ''
      seat seat0 xcursor_theme "capitaine-cursors"
      seat seat0 hide_cursor 60000
    '';
  };
}
