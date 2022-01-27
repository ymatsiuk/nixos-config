{ config, pkgs, lib, ... }:
{
  imports =
    [
      ./boot.nix
      ./fonts.nix
      ./greetd.nix
      ./opengl.nix
      ./pipewire.nix
      ./users.nix

      ./neovim.nix
      ./zsh.nix
    ];

  networking = {
    hostName = "nixps";
    firewall.enable = false;
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    useDHCP = false;
    # fix iwd race by disabling iface management
    wireless.iwd.settings.General.UseDefaultInterface = true;
  };

  time.timeZone = "Europe/Amsterdam";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nl_NL.UTF-8";
    };
  };

  environment = {
    shells = [ pkgs.zsh ];
    pathsToLink = [ "/libexec" "/share/zsh" ];
    variables = {
      LPASS_AGENT_TIMEOUT = "0";
      MANPAGER = "nvim +Man!";
      NIXPKGS_ALLOW_UNFREE = "1";
    };
  };

  hardware = {
    bluetooth = { enable = true; settings = { General = { Experimental = true; }; }; };
    cpu.intel.updateMicrocode = true;
    firmware = with pkgs; [ linux-firmware sof-firmware wireless-regdb ];
    video.hidpi.enable = true;
  };

  powerManagement.cpuFreqGovernor = "powersave";

  programs.light.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures = { base = true; gtk = true; };
    extraPackages = with pkgs; [
      capitaine-cursors #sway/gtk dep
      dmenu-wayland #sway dep
      gsimplecal #i3status-rust dep
      light #sway dep
      pavucontrol #i3status-rust dep
      playerctl #sway dep
      pulseaudio #i3status-rust dep
      sway-contrib.grimshot #sway dep
      swayidle #sway dep
      swaylock #sway dep
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

  sound.enable = true;

  virtualisation.podman.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
    gtkUsePortal = true;
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
