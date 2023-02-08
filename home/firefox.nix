{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "extensions.pocket.enabled" = false;
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;
          "layers.acceleration.force-enabled" = true;
          "layers.force-active" = true;
          "privacy.webrtc.legacyGlobalIndicator" = true; # disabling breaks screen sharing starting from v106 :facepalm.gif:
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          lastpass-password-manager
          decentraleyes
          multi-account-containers
          ublock-origin
          bitwarden
        ];
      };
    };
  };
}
