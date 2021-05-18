{
  imports = [
    ./home/alacritty.nix
    ./home/firefox.nix
    ./home/gammastep.nix
    ./home/git.nix
    ./home/gtk.nix
    ./home/i3status-rust.nix
    ./home/mako.nix
    ./home/mpris-proxy.nix
    ./home/mpv.nix
    ./home/neovim.nix
    ./home/starship.nix
    ./home/sway.nix
    ./home/zsh.nix
    ./modules/git.nix
  ];
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.htop.enable = true;
  xdg.userDirs.enable = true;
}
