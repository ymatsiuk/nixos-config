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
    rev = "d02d55c2c7574218d5f23a7eaef42c6c2f19805e";
    sha256 = "sha256-frDe8/yATljvUvjgVgcLw/uG/lfx+425yJi6XJJLxjQ=";
  };
} // (args.argsOverride or { }))
