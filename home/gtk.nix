{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "gruvbox-dark";
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-size = 16
      gtk-cursor-theme-name = "capitaine-cursors"
    '';
    gtk3.extraConfig = {
      gtk-cursor-theme-size = 16;
      gtk-cursor-theme-name = "capitaine-cursors";
    };
  };
  home.pointerCursor = {
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
  };
}
