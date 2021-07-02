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
      rev = "3d3ff5917ce204b783f4847c14e8839fde358a3a";
      sha256 = "sha256-wJeAkAErWgz9tpLBP6YzUJ9VMDhZ87ruHlNlUIahLto=";
    };
  } // (args.argsOverride or { }))
