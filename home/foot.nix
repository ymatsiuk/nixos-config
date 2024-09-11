{ pkgs, ... }:
{
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
        term = "xterm-256color";
        font = "Iosevka:size=12";
        dpi-aware = "yes";
      };
      scrollback = {
        lines = 5000;
        multiplier = 5;
      };
    };
  };
}
