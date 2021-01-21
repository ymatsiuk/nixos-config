{ pkgs, ... }:

{
  imports = [
    <home-manager/nixos>
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.users.ymatsiuk = { pkgs, ... }: {
    imports = [
      ./home/alacritty.nix
      ./home/dunst.nix
      ./home/git.nix
      ./home/gtk.nix
      ./home/i3status-rust.nix
      ./home/redshift.nix
      # rofi migration in progress
      # ./home/rofi.nix
      ./home/starship.nix
      ./home/zsh.nix
      ./modules/git.nix
    ];
    home.packages = with pkgs ; [
      autocutsel #sync clipboard
      awscli2
      dogdns
      eksctl
      fluxcd
      gitAndTools.gh
      gitAndTools.git-remote-codecommit #AWS codeCommit
      gnumake
      go
      google-chrome
      gsimplecal iw #i3status-rust deps
      kubernetes-helm
      kubectl
      kustomize
      lastpass-cli
      libnotify
      libsecret
      light
      patchelf
      ripgrep
      scrot
      slack
      terraform_0_13
      xclip
    ];

    programs.fzf.enable = true;
    programs.gpg.enable = true;
    programs.htop.enable = true;
    services.network-manager-applet.enable = true;
    services.pasystray.enable = true;
  };
}
