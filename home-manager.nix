{ pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.ymatsiuk = { pkgs, ... }: {
    imports = [
      ./home/alacritty.nix
      ./home/chromium.nix
      # ./home/dunst.nix
      ./home/firefox.nix
      ./home/git.nix
      ./home/gtk.nix
      ./home/i3status-rust.nix
      ./home/mako.nix
      ./home/mpris-proxy.nix
      ./home/mpv.nix
      ./home/qutebrowser.nix
      # rofi migration in progress
      # ./home/rofi.nix
      ./home/starship.nix
      ./home/sway.nix
      ./home/gammastep.nix
      ./home/zsh.nix
      ./modules/git.nix
    ];
    programs.fzf.enable = true;
    programs.gpg.enable = true;
    programs.htop.enable = true;
  };
}
