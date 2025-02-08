{
  imports = [
    ./mosquitto.nix
    ./zigbee2mqtt.nix
  ];

  boot = {
    extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="NL"
    '';
    extraModulePackages = [ ];
    kernelModules = [ "kvm-intel" ];
    tmp.useTmpfs = true;

    kernelParams = [
      "quiet"
      "i915.force_probe=!46d1"
      "xe.force_probe=46d1"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "1"; # bigger font in boot menu
      timeout = 1;
    };

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "sdhci_pci"
      ];
      compressor = "xz";
      luks.devices = {
        nixlab = {
          crypttabExtraOpts = [ "tpm2-device=auto" ];
          device = "/dev/disk/by-uuid/3543b803-fcff-4f90-af2f-154f71a08249";
        };
      };
      systemd = {
        enable = true;
        emergencyAccess = true;
      };
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  security.rtkit.enable = true;
  security.tpm2.enable = true;

  services.fwupd.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/505d260b-868b-418e-928d-d7533b573f33";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/750B-B5FE";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/78eccb23-f47b-4746-b5b5-bb157c303fda"; }
  ];

  services.openssh.enable = true;
}
