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
      rev = "a17b5bdede97e57b27c84c45eb218eac0a3f7739";
      sha256 = "sha256-eXwZnZnEf7WcU4MyMoMrpKYxZSAbUWpFQCNpEkqyq2U=";
    };
  } // (args.argsOverride or { }))
