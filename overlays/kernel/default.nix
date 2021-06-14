{ lib, buildPackages, fetchgit, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:
buildLinux (args // rec {
  version = "5.13.0_drm-tip";
  modDirVersion = "5.13.0-rc5";
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
    rev = "2bba812cf661cf2ffa2874a30d4a2c8fcb3937cc";
    sha256 = "sha256-uqR299fGRd0sX8OfUnIPfusE5xpY56Jy+KGINRa8CK4=";
  };
} // (args.argsOverride or { }))
