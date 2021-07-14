{ lib, buildPackages, fetchgit, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:
buildLinux
  (args // rec {
    version = "5.14.0-drm_tip";
    modDirVersion = "5.14.0-rc1";
    extraMeta.branch = "5.14";
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
      rev = "ea6974acd4fe82ca98cc1390b21af67d63c22471";
      sha256 = "sha256-tDPMSBbw+8pKnreHdXT1DJThzXtms843MZtmHOORHVA=";
    };
  } // (args.argsOverride or { }))
