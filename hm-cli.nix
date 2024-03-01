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
    jq
    kind
    kubectl
    kustomize
    nixpkgs-fmt
    nixpkgs-review
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
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        helm-diff
        helm-unittest
      ];
    })
    (google-cloud-sdk.withExtraComponents ([
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.cloud_sql_proxy
      google-cloud-sdk.components.cbt
    ]))
  ];
  home.stateVersion = "23.11";
}
