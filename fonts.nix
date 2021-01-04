{ pkgs, ... }:

{
  fonts = {
    fontconfig = {
      enable = true;
      antialias = true;
    };
    enableDefaultFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      font-awesome
      font-awesome_4
      iosevka
      powerline-fonts
      roboto
      terminus_font
      ubuntu_font_family
      inconsolata
    ];
  };
}
