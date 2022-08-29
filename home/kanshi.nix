{
  services.kanshi = {
    enable = true;
    profiles = {
      internal = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 2.0;
          }
        ];
      };
      external = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "LG Electronics LG HDR 4K 0x0000C950";
            status = "enable";
            scale = 2.0;
          }
        ];
      };
    };
  };
}
