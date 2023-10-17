{ pkgs, ... }:

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
  ];
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.htop.enable = true;
  home.packages = with pkgs;[
    android-tools
    aws-iam-authenticator
    aws-sso-cli
    awscli2
    delve
    dogdns
    eza
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
    nixpkgs-fmt
    nixpkgs-review
    open-policy-agent
    openssl
    procps
    ripgrep
    sops
    terraform
    terragrunt
    unzip
    vault
    xdg-utils
    yq-go
    (google-cloud-sdk.withExtraComponents ([
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ]))
  ];
  home.stateVersion = "23.11";
}
