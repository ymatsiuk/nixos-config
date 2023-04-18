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
    exa
    fd
    gcc
    (ymatsiuk.google-cloud-sdk.withExtraComponents ([
      ymatsiuk.google-cloud-sdk.components.gke-gcloud-auth-plugin
    ]))
    gnumake
    go
    golangci-lint
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
    vault
    yq-go
    zoom-us
  ];
  home.stateVersion = "22.05";
}
