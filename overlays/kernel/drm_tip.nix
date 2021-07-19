{ lib, buildPackages, fetchgit, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:
buildLinux
  (args // rec {
    version = "5.14.0-drm_tip";
    modDirVersion = "5.14.0-rc2";
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
      rev = "0da7e60301374bc5d2d53573b061cad7f6e2959e";
      sha256 = "sha256-dj4mIQhYBNkcab99Kzxdz3ghRhjJNn+M/2EcvdP+Lug=";
    };
  } // (args.argsOverride or { }))
