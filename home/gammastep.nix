{
  services.gammastep = {
    enable = true;
    latitude = "52.2";
    longitude = "4.5";
    settings = {
      # otherwise causes funky color tilt
      general = { fade = 0; };
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };
}
