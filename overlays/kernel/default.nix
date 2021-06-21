{ lib, buildPackages, fetchgit, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:
buildLinux (args // rec {
  version = "5.13.0_drm-tip";
  modDirVersion = "5.13.0-rc7";
  extraMeta.branch = "5.13";
  ignoreConfigErrors = true;
  enableParallelBuilding = true;
  extraConfig = ''
    CONFIG_DEBUG_LIST y
    CONFIG_SOFTLOCKUP_DETECTOR y
    CONFIG_HARDLOCKUP_DETECTOR y
    CONFIG_DETECT_HUNG_TASK y
    CONFIG_WQ_WATCHDOG y
  '';
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "b6c631d4b0b55b47b95763da2df57e40ba55f283";
    sha256 = "sha256-yN2a+tFgRnx9Jw0h7gWoKsoQo64nIf1tmvHxQEXWGC0=";
  };
} // (args.argsOverride or { }))
