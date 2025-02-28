{ pkgs, ... }:
{
  programs.adb.enable = true;
  users.users.ymatsiuk.extraGroups = [ "adbusers" ];
  programs.droidcam.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.droidcam-obs
      obs-studio-plugins.obs-backgroundremoval
      obs-studio-plugins.obs-composite-blur
      obs-studio-plugins.obs-shaderfilter
      obs-studio-plugins.wlrobs
    ];
  };
}
