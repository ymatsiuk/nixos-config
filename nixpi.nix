{ pkgs, modulesPath, lib, ... }:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
    ./sdimage.nix
  ];

  boot = {
    initrd.availableKernelModules = lib.mkForce [ ];
    tmp.cleanOnBoot = true;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="NL"
    '';
  };

  hardware.enableRedistributableFirmware = lib.mkForce false;

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  services.openssh.enable = true;

  swapDevices = [
    { device = "/swapfile"; size = 2048; }
  ];
}
