{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme.name = "Adwaita";
    gtk2.extraConfig = ''
      gtk-cursor-theme-size = 16
      gtk-cursor-theme-name = "capitaine-cursors"
    '';
    gtk3.extraConfig = {
      gtk-cursor-theme-size = 16;
      gtk-cursor-theme-name = "capitaine-cursors";
    };
  };
}
