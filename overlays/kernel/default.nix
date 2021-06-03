{ lib, buildPackages, fetchgit, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:
buildLinux (args // rec {
  version = "5.13.0_drm-tip";
  modDirVersion = "5.13.0-rc4";
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
    rev = "14fc8c382389c84c90e7a21f01bd67513daa9778";
    sha256 = "sha256-ExyIiA9xdMeVEFNWHohpFgbQGWqIGIkn8fmu8Y4I6jY=";
  };
} // (args.argsOverride or { }))
