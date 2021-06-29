{ lib, buildPackages, fetchgit, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:
buildLinux
  (args // rec {
    version = "5.13.0-drm_tip";
    modDirVersion = "5.13.0-rc7";
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
      rev = "e65a658751fc5d3be5b0f4bcc4731e66ca1a537a";
      sha256 = "sha256-+Br0Um/alzBIFHdwU49jF9BE57kczURaDw4BLB81wGA=";
    };
  } // (args.argsOverride or { }))
