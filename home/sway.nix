{ pkgs, lib, config, ... }:

let
  idleCmd = ''swayidle -w \
    timeout 300 'swaylock --daemonize --ignore-empty-password --color 3c3836' \
    timeout 600 'swaymsg "output * dpms off"' \
         resume 'swaymsg "output * dpms on"' \
    before-sleep 'swaylock --daemonize --ignore-empty-password --color 3c3836'
  '';
  gsettings = "${pkgs.glib}/bin/gsettings";
  gtkSettings = import ./gtk.nix { inherit pkgs; };
  gnomeSchema = "org.gnome.desktop.interface";
  systemdRun = { pkg, bin ? pkg.pname, args ? "" }: ''
    systemd-run --user --scope --collect --quiet --unit=${bin} \
    systemd-cat --identifier=${bin} ${lib.makeBinPath [ pkg ]}/${bin} ${args}
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
    systemd.enable = true;
    config = {
      gaps = {
        smartBorders = "on";
      };
      fonts = {
        names = [ "Iosevka" "Font Awesome 6 Free" "Font Awesome 6 Brands" ];
      };
      modifier = "Mod4";
      menu = "tofi-drun --drun-launch=true";
      terminal = "wezterm start --always-new-process";
      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          "${mod}+Shift+e" = "exit";
          "${mod}+Shift+f" = "exec firefox";
          "${mod}+Shift+s" = "exec ${systemdRun { pkg = pkgs.master.slack; args= "--logLevel=error";} }";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86MonBrightnessDown" = "exec light -U 5%";
          "XF86MonBrightnessUp" = "exec light -A 5%";
          "--release Print" = "exec grimshot --notify save area ~/scr/scr_`date +%Y%m%d.%H.%M.%S`.png";
          "--release ${mod}+Print" = "exec grimshot --notify save output ~/scr/scr_`date +%Y%m%d.%H.%M.%S`.png";
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
          fonts = {
            names = [ "Iosevka" "Font Awesome 6 Free" "Font Awesome 6 Brands" ];
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
      output = {
        DP-1 = { pos = "0 0"; scale = "2"; };
        eDP-1 = { pos = "0 1080"; scale = "2"; };
      };
      window = {
        titlebar = false;
        hideEdgeBorders = "smart";
        commands = [
          { command = "floating enable"; criteria = { app_id = "gsimplecal"; }; }
          { command = "floating enable"; criteria = { app_id = "firefox-nightly"; title = "About Firefox Nightly"; }; }
          { command = "move container to workspace 2"; criteria = { app_id = "^(?i)slack$"; }; }
          { command = "move container to workspace 3"; criteria = { app_id = "firefox-nightly"; }; }
          { command = "floating enable, resize set width 600px height 800px"; criteria = { title = "Save File"; }; }
          # browser zoom|meet|bluejeans
          { command = "inhibit_idle visible"; criteria = { title = "(Blue Jeans)|(Meet)|(Zoom Meeting)"; }; }
          { command = "inhibit_idle visible, floating enable"; criteria = { title = "(Sharing Indicator)"; }; }
        ];
      };
      startup = [
        { command = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY DBUS_SESSION_BUS_ADDRESS SWAYSOCK XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP NIXOS_OZONE_WL"; } #workaround
        { command = "${idleCmd}"; }
        { command = "${importGsettings}"; always = true; }
        { command = "wezterm start --always-new-process"; }
        { command = "firefox"; }
        { command = "${systemdRun { pkg = pkgs.master.slack; args= "--logLevel=error";} }"; }
      ];
    };
    extraConfig = ''
      seat seat0 xcursor_theme "capitaine-cursors"
      seat seat0 hide_cursor 60000
    '';
  };
}

