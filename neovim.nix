{ config, pkgs, lib, ... }:

let
  neovim = pkgs.neovim.override {
    configure = {
      customRC = builtins.readFile ./init.vim;
      plug.plugins = with pkgs.vimPlugins; [
        vim-nix
        gruvbox
        vim-airline-themes
        vim-airline
        colorizer
        vim-go
        vim-terraform
        vim-packer
        vim-commentary
        vim-lastplace
        vim-fugitive
      ];
    };
  };
in {
  environment = {
    shellAliases = { vi = "nvim"; vim = "nvim"; };
    systemPackages = [ neovim ];
    variables = { EDITOR = "nvim"; VISUAL = "nvim"; };
  };
}
