{
  services.wlsunset = {
    enable = true;
    latitude = "52.2226";
    longitude = "4.5322";
    temperature = {
      day = 5500;
      night = 3700;
    };
  };
  systemd.user.services.wlsunset.Service = {
    Restart = "always";
    RestartSec = 3;
  };
}
