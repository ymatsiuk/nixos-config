{ lib, config, ... }:
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      floating.titlebar = false;
      window = {
        titlebar = false;
        hideEdgeBorders = "smart";
        commands = [
          { command = "floating enable"; criteria = { class = "(?i)gsimplecal"; } ; }
          { command = "move to workspace $w2"; criteria = { class = "(?i)qutebrowser"; } ; }
          { command = "floating enable, move position center"; criteria = { window_role = "GtkFileChooserDialog"; } ; }
        ];
      };
      fonts = [ "Iosevka 9" ];
      modifier = "Mod4";
      terminal = "alacritty";
      modes = {
        resize = {
          Escape = "mode default";
          Return = "mode default";
          Left = "resize shrink width 10 px or 10 ppt";
          Down = "resize grow height 10 px or 10 ppt";
          Up = "resize shrink height 10 px or 10 ppt";
          Right = "resize grow width 10 px or 10 ppt";
          h = "resize shrink width 10 px or 10 ppt";
          j = "resize grow height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          l = "resize grow width 10 px or 10 ppt";
        };
      };
      keybindings =
        let
          mod = config.xsession.windowManager.i3.config.modifier;
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
            "${mod}+b" = "split h";
            "${mod}+v" = "split v";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus left";
            "${mod}+h" = "focus right";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move left";
            "${mod}+Shift+h" = "move right";
            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessDown" = "exec --no-startup-id light -U 5%";
            "XF86MonBrightnessUp" = "exec --no-startup-id light -A 5%";
            "--release Print" = "exec \"scrot -s \${HOME}/scr/scr_`date +%Y%m%d.%H.%M.%S`.png\"";
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
          fonts = [ "Iosevka 9" ];
          position = "bottom";
          extraConfig = "tray_output eDP-1";
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
      startup = [
        { command = "light -S 25%"; always = false; notification = false; }
        { command = "alacritty"; always = false; notification = false; }
        { command = "qutebrowser"; always = false; notification = false; }
        { command = "appgate"; always = false; notification = false; }
        { command = "google-chrome-stable"; always = false; notification = false; }
      ];
      assigns = {
        "$w2" = [{ class = "^(?i)qutebrowser$"; }];
        "$w3" = [{ class = "^(?i)google-chrome$"; }];
        "$w4" = [{ class = "^(?i)appgate sdp$"; }];
      };
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
  '';
  };
}
