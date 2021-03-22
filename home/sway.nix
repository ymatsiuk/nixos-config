{ pkgs, lib, config, ...}:

let
  lockCmd = "${pkgs.swaylock}/bin/swaylock --daemonize --show-failed-attempts --indicator-caps-lock --color '#282828'";
  idleCmd = ''${pkgs.swayidle}/bin/swayidle -w \
    timeout 300 "${lockCmd}" \
    timeout 600 "swaymsg 'output * dpms off'" \
    resume "swaymsg 'output * dpms on'" \
    before-sleep "${lockCmd}"'';
  gsettings="${pkgs.glib}/bin/gsettings";
  gtkSettings = import ./gtk.nix { inherit pkgs; };
  gnomeSchema="org.gnome.desktop.interface";
  importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
    ${gsettings} set ${gnomeSchema} gtk-theme ${gtkSettings.gtk.theme.name}
    ${gsettings} set ${gnomeSchema} icon-theme ${gtkSettings.gtk.iconTheme.name}
    ${gsettings} set ${gnomeSchema} cursor-theme ${gtkSettings.gtk.gtk3.extraConfig.gtk-cursor-theme-name}
  '';
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true ;
    config = {
      gaps = {
        smartBorders = "on";
      };
      fonts = [ "Iosevka" ];
      modifier = "Mod4";
      menu = "${pkgs.dmenu-wayland}/bin/dmenu-wl_run -i";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
          lib.mkOptionDefault {
            "${mod}+Shift+e" = "exit";
            "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
            "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
            "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
            "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec ${pkgs.pulseaudioFull}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5%";
            "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5%";
            "--release Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save area ~/scr/scr_`date +%Y%m%d.%H.%M.%S`.png";
            "--release ${mod}+Print" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save output ~/scr/scr_`date +%Y%m%d.%H.%M.%S`.png";
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
          fonts = [ "Iosevka 10" ];
          position = "bottom";
          extraConfig =
          "
            tray_output eDP-1
          ";
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
      output = {
        eDP-1 = {
          subpixel = "rgb";
          scale = "2";
        };
      };
      window = {
        titlebar = false;
        hideEdgeBorders = "smart";
        commands = [
          { command = "floating enable"; criteria = { app_id = "gsimplecal"; } ; }
          { command = "floating enable"; criteria = { app_id = "chromium"; } ; }
          { command = "floating enable"; criteria = { app_id = "mpv"; }; }
          { command = "floating enable, move scratchpad"; criteria = { class = "Appgate SDP"; }; }
          { command = "floating enable, resize set width 600px height 800px"; criteria = { title = "Save File"; }; }
          { command = "inhibit_idle visible, floating enable"; criteria = { title = "(is sharing your screen)|(Sharing Indicator)"; }; }
          { command = "inhibit_idle visible"; criteria = { title = "(Blue Jeans Network)|(Meet)"; }; }
          { command = "move container to workspace 2"; criteria = { app_id = "^(?i)org.qutebrowser.qutebrowser$"; }; }
          { command = "move container to workspace 3"; criteria = { app_id = "^(?i)Chromium-browser$"; }; }
          { command = "move container to workspace 4"; criteria = { app_id = "^(?i)Firefox$"; }; }
        ];
      };
      startup = [
        { command = "${idleCmd}"; }
        { command = "${importGsettings}"; always = true; }
        { command = "alacritty"; always = false; }
        { command = "${pkgs.appgate-sdp}/bin/appgate"; always = false; }
        { command = "chromium"; always = false; }
        { command = "${pkgs.light}/bin/light -S 35%"; always = false; }
        { command = "qutebrowser"; always = false; }
      ];
    };
  extraConfig =
  ''
    seat seat0 xcursor_theme "capitaine-cursors"
    seat seat0 hide_cursor 60000
  '';
  };
}
