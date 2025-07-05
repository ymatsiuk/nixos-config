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
    _1password-cli
    aws-iam-authenticator
    aws-sso-cli
    awscli2
    cmctl
    delve
    gcc
    gnumake
    go
    golangci-lint
    k9s
    kind
    kubectl
    kustomize
    postgresql # psql
    redis # redis-cli
    sslscan
    terraform
    vault-bin
    yq-go
    wol
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-diff
        helm-unittest
      ];
    })
  ];
}
