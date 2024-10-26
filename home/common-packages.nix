{ pkgs, ... }:
{
  home.packages = with pkgs;[
    dogdns
    eza
    fd
    jq
    nixpkgs-fmt
    alejandra
    nixfmt-rfc-style
    nixpkgs-review
    openssl
    procps
    ripgrep
    unzip
    xdg-utils
  ];
}
