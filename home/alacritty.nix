{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
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
      env.TERM = "xterm-256color";
      font = {
        size = 12;
      };
      hints = {
        enabled = [
          {
            regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+";
            command = "${pkgs.xdg-utils}/bin/xdg-open";
            post_processing = true;
            mouse = {
              enabled = true;
              mods = "Alt";
            };
          }
        ];
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };
}
