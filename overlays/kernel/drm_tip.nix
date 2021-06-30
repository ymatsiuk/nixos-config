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
      rev = "0a36f63231dfcbc850d12c64dae9f09b07345101";
      sha256 = "sha256-vfsIV5gf1OgeMrhN2MNkElIXnCU9Y+JElxtf5QxLrNc=";
    };
  } // (args.argsOverride or { }))
