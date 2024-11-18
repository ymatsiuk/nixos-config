{ pkgs, config, ... }:
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
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.htop.enable = true;
  home.stateVersion = "25.05";
  home.activation.report-changes = config.lib.dag.entryAnywhere ''
    ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff $oldGenPath $newGenPath
  '';
}
