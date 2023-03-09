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
            criteria = "DP-1";
            status = "enable";
            scale = 2.0;
          }
        ];
      };
    };
  };
}
