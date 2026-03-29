{ pkgs, ... }:
{
  gtk = {
    enable = true;
    colorScheme = "dark";
    cursorTheme = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 16;
    };
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "gruvbox-dark";
    };
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };
  };
}
