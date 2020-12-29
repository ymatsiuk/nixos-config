{
  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 5;
    shadow = true;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = 0.7;
    shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];
    activeOpacity = 1.0;
    inactiveOpacity = 0.8;
    menuOpacity = 0.8;
    backend = "glx";
    vSync = true;
  };
}
