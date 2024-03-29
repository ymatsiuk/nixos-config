{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          decentraleyes
          multi-account-containers
          ublock-origin
        ];
      };
    };
  };
}
