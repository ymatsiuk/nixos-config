{ pkgs, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/nix-community/home-manager";
    rev = "64c5228c0828fff0c94c1d42f7225115c299ae08";
    ref = "master";
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.ymatsiuk = { pkgs, ... }: {
    imports = [
      ./home/alacritty.nix
      ./home/firefox.nix
      ./home/git.nix
      ./home/gtk.nix
      ./home/i3status-rust.nix
      ./home/neovim.nix
      ./home/mako.nix
      ./home/mpris-proxy.nix
      ./home/mpv.nix
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
