{
  services.kanshi = {
    enable = true;
    profiles = {
      internal = {
        outputs = [
          {
            criteria = "Sharp Corporation 0x14FA";
            status = "enable";
            scale = 2.0;
          }
        ];
      };
      external = {
        outputs = [
          {
            criteria = "Sharp Corporation 0x14FA";
            status = "disable";
          }
          {
            criteria = "LG Electronics LG HDR 4K";
            status = "enable";
            scale = 2.0;
          }
        ];
      };
    };
  };
}
