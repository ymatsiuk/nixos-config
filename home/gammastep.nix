let
  secrets = import ../secrets.nix;
in
{
  services.gammastep = {
    enable = true;
    latitude = secrets.gammastep.latitude;
    longitude = secrets.gammastep.longitude;
    temperature = {
      day = 5500;
      night = 3700;
    };
  };
}
