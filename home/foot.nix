{ pkgs, ... }:
{
  programs.fuzzel.enable = true;
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
        term = "xterm-256color";
        font = "Iosevka:size=12";
        selection-target = "both";
      };
      scrollback = {
        lines = 10000;
        multiplier = 5;
      };
    };
  };
}
