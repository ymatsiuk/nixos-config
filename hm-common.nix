{
  imports = [
    ./home/git.nix
    ./home/neovim.nix
    ./home/rbw.nix
    ./home/starship.nix
    # terminals here for terminfo/ssh
    ./home/alacritty.nix
    ./home/foot.nix
    ./home/wezterm.nix
    # packages common to all hosts
    ./home/common-packages.nix
  ];
  programs.gpg.enable = true;
  programs.htop.enable = true;
  home.stateVersion = "23.11";
}
