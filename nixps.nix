{ config, pkgs, lib, ... }:
{
  imports =
    [
      ./boot.nix
      ./fonts.nix
      ./greetd.nix
      ./opengl.nix
      ./pipewire.nix
    ];

  hardware = {
    bluetooth = { enable = true; settings.General.Experimental = true; };
    cpu.intel.updateMicrocode = true;
    video.hidpi.enable = true;
  };

  home-manager.users.ymatsiuk = import ./hm-gui.nix;

  powerManagement.cpuFreqGovernor = "powersave";

  programs.light.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures = { base = true; gtk = true; };
    extraPackages = with pkgs; [
      capitaine-cursors #sway/gtk dep
      gsimplecal #i3status-rust dep
      light #sway dep
      obs-studio
      obs-studio-plugins.wlrobs
      pavucontrol #i3status-rust dep
      playerctl #sway dep
      pulseaudio #i3status-rust dep
      master.slack
      sway-contrib.grimshot #sway dep
      swayidle #sway dep
      swaylock #sway dep
      tofi #sway dep
      wf-recorder #sway
      wl-clipboard #sway dep
    ];
  };

  security.rtkit.enable = true;
  security.tpm2.enable = true;

  services.fwupd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    extraOptions = ''--config-file=${
      pkgs.writeText "daemon.json" (builtins.toJSON {
        features = { buildkit = true; };
      })
    }'';
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/bcde03fe-099f-4d2f-8019-5d56bb72c347";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/60D0-040B";
      fsType = "vfat";
    };
  };
  swapDevices = [{
    device = "/dev/disk/by-uuid/c96e5a66-6a1b-4f8f-b504-c3a0d56ad19b";
  }];
}
