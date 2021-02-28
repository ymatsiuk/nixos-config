{
  services.xserver = {
    enable = true;
    dpi = 220;
    videoDrivers = [ "modesetting" ];

    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
        accelSpeed = "0.5";
      };
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm.greeters.gtk = {
        indicators = [ "~clock" "~session" "~power" ];
        theme.name = "Adwaita-black";
        cursorTheme = {
          size = 32;
        };
      };
    };

    windowManager.i3 = {
      enable = true;
    };
  };
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
