{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "internal";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 2.5;
          }
        ];
      }
      {
        profile.name = "external";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "LG Electronics LG HDR 4K 0x0001C950";
            status = "enable";
            scale = 2.0;
          }
        ];
      }
    ];
  };
}
