{ pkgs, ... }:

{
  imports = [
    ./home/git.nix
    ./home/starship.nix
  ];
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.htop.enable = true;
  home.packages = with pkgs;[
    android-tools
    aws-iam-authenticator
    aws-vault
    awscli2
    awsvpnclient
    black
    boundary
    exa
    fd
    fluxcd
    gcc
    gnumake
    go
    golangci-lint
    idasen-cli
    jq
    kind
    kubectl
    kubernetes-helm
    kustomize
    lastpass-cli
    minikube
    nixpkgs-fmt
    nixpkgs-review
    nodePackages.serverless
    openssl
    packer
    podman
    procps
    ripgrep
    saml2aws
    ssm-session-manager-plugin #packer dep
    terraform
    tmate
    vault
    yq-go

    gopls
    rnix-lsp
    nodePackages.pyright
    nodePackages.bash-language-server
    rubyPackages.solargraph
    terraform-ls
  ];
  home.stateVersion = "22.05";
}
