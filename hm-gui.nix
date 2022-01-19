{ pkgs, ... }:

{
  imports = [
    ./home/alacritty.nix
    ./home/firefox.nix
    ./home/gammastep.nix
    ./home/gtk.nix
    ./home/i3status-rust.nix
    ./home/mako.nix
    ./home/mpris-proxy.nix
    ./home/sway.nix
  ];
  xdg.userDirs.enable = true;
  home.packages = with pkgs;[
    capitaine-cursors #sway/gtk dep
    iw #i3status-rust dep
    pulseaudio #i3status-rust dep
    slackWayland
    wf-recorder #sway
    wl-clipboard #sway dep
  ];
}
