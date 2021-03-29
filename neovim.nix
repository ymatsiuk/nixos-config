{ pkgs, ... }:

let
  neovim = pkgs.neovim.override {
    configure = {
      customRC = builtins.readFile ./init.vim;
      plug.plugins = with pkgs.vimPlugins; [
        colorizer
        gruvbox
        vim-airline
        vim-airline-themes
        vim-commentary
        vim-fugitive
        vim-go
        vim-lastplace
        vim-nix
        vim-terraform
      ];
    };
  };
in
{
  environment = {
    systemPackages = [ neovim ];
    variables = { EDITOR = "nvim"; VISUAL = "nvim"; };
  };
}
