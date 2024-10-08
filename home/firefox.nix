{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
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
