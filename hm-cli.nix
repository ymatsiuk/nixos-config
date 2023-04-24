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
    android-tools
    aws-iam-authenticator
    aws-sso-cli
    awscli2
    dogdns
    exa
    exercism
    fd
    gcc
    gnumake
    go
    golangci-lint
    iperf
    jq
    kind
    kubectl
    kubernetes-helm
    kustomize
    lastpass-cli
    nixpkgs-fmt
    nixpkgs-review
    openssl
    procps
    ripgrep
    terraform
    unzip
    vault
    yq-go
    zoom-us
    (master.google-cloud-sdk.withExtraComponents ([
      master.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ]))
  ];
  home.stateVersion = "22.05";
}
