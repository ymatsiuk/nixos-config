{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    useGlamor = true;
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
        theme.name = "gruvbox-dark-gtk";
        cursorTheme = {
          size = 32;
        };
      };
    };

    windowManager.i3 = {
      enable = true;
    };
  };
}
