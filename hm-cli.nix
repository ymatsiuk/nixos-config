{ pkgs, ... }:

{
  imports = [
    ./home/git.nix
    ./home/starship.nix
    ./modules/git.nix
  ];
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.htop.enable = true;
  home.packages = with pkgs;[
    aws-vault
    awscli2
    exa
    fd
    fluxcd
    gcc
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
    packer
    podman
    procps
    ripgrep
    ssm-session-manager-plugin #packer dep
    teleport.client
    terraform

    gopls
    rnix-lsp
    nodePackages.pyright
    nodePackages.bash-language-server
    rubyPackages.solargraph
    terraform-ls
  ];
  home.stateVersion = "22.05";
}
