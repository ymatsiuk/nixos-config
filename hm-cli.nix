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
    aws-sso-cli
    awscli2
    awsvpnclient
    exa
    fd
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
    nixpkgs-fmt
    nixpkgs-review
    nodePackages.serverless
    openssl
    procps
    ripgrep
    terraform
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
