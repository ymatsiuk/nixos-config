{ pkgs, ... }:
{
  imports = [
    ./apfs.nix
    ./boot.nix
    ./fonts.nix
    ./greetd.nix
    ./opengl.nix
    ./pipewire.nix
    ./tailscale.nix
  ];

  hardware.cpu.intel.updateMicrocode = true;

  home-manager.users.ymatsiuk = import ./hm-nixps.nix;

  powerManagement.cpuFreqGovernor = "powersave";

  programs.light.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures = {
      base = true;
      gtk = true;
    };
    extraPackages = with pkgs; [
      grim # sway dep
      gsimplecal # i3status-rust dep
      light # sway dep
      pavucontrol # i3status-rust dep
      playerctl # sway dep
      pulseaudio # i3status-rust dep
      slack
      slurp # sway dep
      swayidle # sway dep
      swaylock # sway dep
      wf-recorder # sway
      wl-clipboard # sway dep
    ];
  };

  security.rtkit.enable = true;
  security.tpm2.enable = true;

  services.fprintd = {
    enable = true;
    tod = {
      driver = pkgs.libfprint-2-tod1-goodix;
      enable = true;
    };
  };
  services.fwupd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/14f07d10-2d6b-478c-b773-3eeebffccbc8";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/32C5-B301";
      fsType = "vfat";
    };
  };
  swapDevices = [
    {
      device = "/dev/disk/by-uuid/8f3d360d-9fea-44d2-802e-f9ccfe932521";
    }
  ];
}
