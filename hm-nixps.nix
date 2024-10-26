{ pkgs, ... }:
{
  imports = [
    ./home/firefox.nix
    ./home/gammastep.nix
    ./home/gtk.nix
    ./home/i3status-rust.nix
    ./home/kanshi.nix
    ./home/mako.nix
    ./home/sway.nix
  ];
  xdg.userDirs.enable = true;
  home.packages = with pkgs; [
    _1password
    aws-iam-authenticator
    aws-sso-cli
    awscli2
    delve
    exercism
    fluxcd
    gcc
    gnumake
    go
    golangci-lint
    kind
    kubectl
    kustomize
    step-cli
    postgresql
    terraform
    yq-go
    zoxide
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-diff
        helm-unittest
      ];
    })
  ];
}
