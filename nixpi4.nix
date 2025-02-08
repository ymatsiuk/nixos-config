{ lib, ... }:
{
  imports = [
    ./cloudflared.nix
    ./grafana.nix
    ./homeassistant.nix
    ./mosquitto.nix
  ];

  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="NL"
  '';

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/a58ae62a-1358-42cb-81c9-971fdef73510";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/1C3B-1E13";
      fsType = "vfat";
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/4918387b-8275-4f05-9938-b18ac7ca2df0"; } ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  services.openssh.enable = true;
}
