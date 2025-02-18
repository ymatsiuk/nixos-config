{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          consent-o-matic
          decentraleyes
          multi-account-containers
          onepassword-password-manager
          ublock-origin
        ];
      };
    };
  };
}
