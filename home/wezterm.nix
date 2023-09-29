{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.color_scheme = 'Gruvbox Dark (Gogh)'
      config.enable_tab_bar = false
      config.font = wezterm.font 'Iosevka'
      config.term = 'wezterm'
      config.window_padding = { left = 2, right = 2, top = 2, bottom = 2, }
      config.animation_fps = 1
      config.cursor_blink_ease_in = 'Constant'
      config.cursor_blink_ease_out = 'Constant'

      return config
    '';
  };
}
