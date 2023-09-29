{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "extensions.pocket.enabled" = false;
          # "gfx.webrender.all" = true;
          # "gfx.webrender.enabled" = true;
          # "layers.acceleration.force-enabled" = true;
          # "layers.force-active" = true;
          # "privacy.webrtc.legacyGlobalIndicator" = true;
        };
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
