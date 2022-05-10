{
  services.kanshi = {
    enable = true;
    profiles = {
      internal = {
        outputs = [
          {
            criteria = "Sharp Corporation 0x14FA 0x00000000";
            status = "enable";
            scale = 2.0;
          }
        ];
      };
      external = {
        outputs = [
          {
            criteria = "Sharp Corporation 0x14FA 0x00000000";
            status = "disable";
          }
          {
            criteria = "Goldstar Company Ltd LG HDR 4K 0x0000C950";
            status = "enable";
            scale = 2.0;
          }
        ];
      };
    };
  };
}
