{ pkgs, ... }:

{
  imports = [
    ./home/alacritty.nix
    ./home/firefox.nix
    ./home/gammastep.nix
    ./home/gtk.nix
    ./home/i3status-rust.nix
    ./home/kanshi.nix
    ./home/mako.nix
    ./home/mpris-proxy.nix
    ./home/sway.nix
  ];
  xdg.userDirs.enable = true;
}
