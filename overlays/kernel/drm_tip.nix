{ lib, buildPackages, fetchgit, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:
buildLinux
  (args // rec {
    version = "5.13.0-drm_tip";
    modDirVersion = "5.13.0";
    extraMeta.branch = "5.13";
    ignoreConfigErrors = true;
    enableParallelBuilding = true;
    kernelPatches = [ ];
    extraConfig = ''
      CONFIG_DEBUG_LIST y
      CONFIG_SOFTLOCKUP_DETECTOR y
      CONFIG_HARDLOCKUP_DETECTOR y
      CONFIG_DETECT_HUNG_TASK y
      CONFIG_WQ_WATCHDOG y
    '';
    src = fetchgit {
      url = "git://anongit.freedesktop.org/drm-tip";
      rev = "683b7f160eb6993ccfc19e67e3c7111f12946bea";
      sha256 = "sha256-8l5Cc3ZdH5yxznQxPcq6MQiccqTbpYOrrd6ACLxgrLA=";
    };
  } // (args.argsOverride or { }))
