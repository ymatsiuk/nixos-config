{ lib, buildPackages, fetchgit, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:
buildLinux (args // rec {
  version = "5.13.0_drm-tip";
  modDirVersion = "5.13.0-rc6";
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
    rev = "e00d16681acd7e91fd02f800adcc20cca89f6127";
    sha256 = "sha256-p1sHrrFr17XI/gN/J4zyKi7w2HeLrP/aeUkn1QYsjsM=";
  };
} // (args.argsOverride or { }))
