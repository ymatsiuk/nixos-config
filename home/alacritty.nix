{
  programs.alacritty = {
    enable = true;
    settings = {
      window.dynamic_padding = true;
      scrolling.multiplier = 5;
      font = {
        normal.family = "Iosevka";
        bold.family = "Iosevka";
        italic.family = "Iosevka";
        bold_italic.family = "Iosevka";
        size = 7;
        draw_bold_text_with_bright_colors = true;
      };
      selection = {
        save_to_clipboard = true;
      };
      mouse = {
        url.modifiers = "Super";
      };
      colors = {
        primary = {
          background = "0x282828";
          foreground = "0xebdbb2";
        };
        normal = {
          black = "0x282828";
          red = "0xcc241d";
          green = "0x98971a";
          yellow = "0xd79921";
          blue = "0x458588";
          magenta = "0xb16286";
          cyan = "0x689d6a";
          white = "0xa89984";
        };
        bright = {
          black = "0x928374";
          red = "0xfb4934";
          green = "0xb8bb26";
          yellow = "0xfabd2f";
          blue = "0x83a598";
          magenta = "0xd3869b";
          cyan = "0x8ec07c";
          white = "0xebdbb2";
        };
      };
    };
  };
}
