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
    ./telegraf.nix
    ./upgrade-diff.nix
  ];

  hardware.cpu.intel.updateMicrocode = true;

  home-manager.users.ymatsiuk = import ./hm-nixps.nix;

  powerManagement.cpuFreqGovernor = "powersave";

  programs.light.enable = true;
  programs.ssh.startAgent = true;
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
  services.udev.extraRules = ''
    # Notify ModemManager this device should be ignored
    ACTION!="add|change|move", GOTO="mm_usb_device_blacklist_end"
    SUBSYSTEM!="usb", GOTO="mm_usb_device_blacklist_end"
    ENV{DEVTYPE}!="usb_device",  GOTO="mm_usb_device_blacklist_end"

    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a2ca", ENV{ID_MM_DEVICE_IGNORE}="1"

    LABEL="mm_usb_device_blacklist_end"


    # Solo bootloader + firmware access
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a2ca", TAG+="uaccess"
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="a2ca", TAG+="uaccess"

    # ST DFU access
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", TAG+="uaccess"

    # U2F Zero
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="8acf", TAG+="uaccess"
  '';
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
