{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      lastpass-password-manager
      decentraleyes
      multi-account-containers
      ublock-origin
      https-everywhere
    ];
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "extensions.pocket.enabled" = false;
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;
          "layers.acceleration.force-enabled" = true;
          "layers.force-active" = true;
          "widget.wayland-dmabuf-vaapi.enabled" = true;
          "widget.content.allow-gtk-dark-theme" = false;
        };
      };
    };
  };
}
