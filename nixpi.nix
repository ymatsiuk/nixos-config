{ pkgs, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./sdimage.nix
  ];

  boot = {
    cleanTmpDir = true;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="NL"
    '';
  };
  services.openssh.enable = true;
  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];
}
