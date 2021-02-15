{ pkgs, lib, config, ...}:

let
  gsettings="${pkgs.glib}/bin/gsettings";
  importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
    config="''${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
    if [ ! -f "$config" ]; then exit 1; fi

    gnome_schema="org.gnome.desktop.interface"
    gtk_theme="$(grep 'gtk-theme-name' "$config" | cut -d'=' -f2)"
    icon_theme="$(grep 'gtk-icon-theme-name' "$config" | cut -d'=' -f2)"
    cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | cut -d'=' -f2)"
    font_name="$(grep 'gtk-font-name' "$config" | cut -d'=' -f2)"
    ${gsettings} set "$gnome_schema" gtk-theme "$gtk_theme"
    ${gsettings} set "$gnome_schema" icon-theme "$icon_theme"
    ${gsettings} set "$gnome_schema" cursor-theme "$cursor_theme"
    ${gsettings} set "$gnome_schema" font-name "$font_name"
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
      terminal = "alacritty";
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
          lib.mkOptionDefault {
            "${mod}+1" = "workspace $w1";
            "${mod}+2" = "workspace $w2";
            "${mod}+3" = "workspace $w3";
            "${mod}+4" = "workspace $w4";
            "${mod}+5" = "workspace $w5";
            "${mod}+6" = "workspace $w6";
            "${mod}+7" = "workspace $w7";
            "${mod}+8" = "workspace $w8";
            "${mod}+9" = "workspace $w9";
            "${mod}+0" = "workspace $w0";
            "${mod}+Shift+1" = "move container to workspace $w1";
            "${mod}+Shift+2" = "move container to workspace $w2";
            "${mod}+Shift+3" = "move container to workspace $w3";
            "${mod}+Shift+4" = "move container to workspace $w4";
            "${mod}+Shift+5" = "move container to workspace $w5";
            "${mod}+Shift+6" = "move container to workspace $w6";
            "${mod}+Shift+7" = "move container to workspace $w7";
            "${mod}+Shift+8" = "move container to workspace $w8";
            "${mod}+Shift+9" = "move container to workspace $w9";
            "${mod}+Shift+0" = "move container to workspace $w0";
            "${mod}+Shift+e" = "exit";
            "${mod}+d" = "exec bemenu-run --fn Iosevka 10 -p ▶  --tf \"#b16286\" | xargs swaymsg exec --";
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessDown" = "exec light -U 5%";
            "XF86MonBrightnessUp" = "exec light -A 5%";
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
          statusCommand = "i3status-rs ~/.config/i3status-rust/config-bottom.toml";
          fonts = [ "Iosevka 10" ];
          position = "bottom";
          extraConfig =
          "
            output eDP-1
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
      startup = [
        { command = "${importGsettings}"; always = true; }
        { command = "light -S 25%"; always = false; }
        { command = "alacritty"; always = false; }
        { command = "appgate"; always = false; }
        # { command = "google-chrome-unstable"; always = false; }
        { command = "chromium"; always = false; }
        # { command = "qutebrowser"; always = false; }
      ];
    };
  extraConfig =
  ''
    set $d0 DP-4
    set $d1 eDP-1
    set $d2 DP-3

    set $w1 1: 
    set $w2 2: 
    set $w3 3: 
    set $w4 4: 
    set $w5 5: 
    set $w6 6: 
    set $w7 7: 
    set $w8 8: 
    set $w9 9: 
    set $w0 10: 

    workspace "$w1" output $d1
    workspace "$w2" output $d1
    workspace "$w3" output $d1
    workspace "$w4" output $d1
    workspace "$w5" output $d0
    workspace "$w6" output $d0
    workspace "$w7" output $d0
    workspace "$w8" output $d2
    workspace "$w9" output $d2
    workspace "$w0" output $d2

    assign [app_id="org.qutebrowser.qutebrowser"] $w2
    assign [app_id="Chromium-browser"] $w3
    assign [class="Appgate SDP"] $w4
    assign [class="Google-chrome-unstable"] $w0

    seat seat0 xcursor_theme "capitaine-cursors"
  '';
  };
}
