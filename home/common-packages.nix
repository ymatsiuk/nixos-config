{ pkgs, ... }:
{
  home.packages = with pkgs;[
    dogdns
    eza
    fd
    jq
    nixpkgs-fmt
    nixpkgs-review
    openssl
    procps
    ripgrep
    unzip
    xdg-utils
  ];
}
