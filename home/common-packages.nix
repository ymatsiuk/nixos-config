{ pkgs, ... }:
{
  home.packages = with pkgs; [
    alejandra
    doggo
    eza
    fd
    inetutils
    jq
    nixfmt-rfc-style
    nixpkgs-fmt
    nixpkgs-review
    openssl
    procps
    ripgrep
    unzip
    xdg-utils
  ];
}
