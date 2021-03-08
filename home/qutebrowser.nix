{
  programs.qutebrowser = {
    enable = true;
    settings = {
      qt.args = [ "enable-native-gpu-memory-buffers" "enable-gpu-rasterization" "use-gl=egl" "ignore-gpu-blacklist" "num-raster-threads=4" ];
      colors.webpage.darkmode.enabled = true;
      spellcheck.languages = [ "en-US" ];
      content = {
        autoplay = false;
        cookies.store = true;
        geolocation = "ask";
        javascript.enabled = true;
        notifications = true;
        ssl_strict = true;
        webgl = true;
      };
    };
    keyBindings.normal.",m" = "hint links spawn mpv {hint-url}";
    keyBindings.normal.",c" = "hint links spawn chromium {hint-url}";
  };
}
