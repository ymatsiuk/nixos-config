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
      rev = "2a9c85f62543f4707a136162460429efd7c87ab9";
      sha256 = "sha256-FNlbPs8OgsIvpyeKxSwl3dMSld0TshjckCHQ7rtezGI=";
    };
  } // (args.argsOverride or { }))
