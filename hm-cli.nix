{ pkgs, ... }:

{
  imports = [
    ./home/git.nix
    ./home/neovim.nix
    ./home/starship.nix
  ];
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.htop.enable = true;
  home.packages = with pkgs;[
    exa
    fd
    nixpkgs-fmt
    procps
    ripgrep
  ];
  home.stateVersion = "22.05";
}
