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
  home.packages = with pkgs;[
    aws-iam-authenticator
    aws-sso-cli
    awscli2
    awsvpnclient
    delve
    exercism
    gcc
    gnumake
    go
    golangci-lint
    kind
    kubectl
    kustomize
    sops
    terraform
    terragrunt
    vault
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
}
