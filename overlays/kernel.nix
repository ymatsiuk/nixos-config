{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc2";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  structuredExtraConfig = with lib.kernel; {
    DEBUG_LIST = yes;
    SOFTLOCKUP_DETECTOR = yes;
    HARDLOCKUP_DETECTOR = yes;
    DETECT_HUNG_TASK = yes;
    WQ_WATCHDOG = yes;
  };
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "8a98b478ac43197a57ca8dca7e37d00f40a21b1e";
    sha256 = "sha256-YiNo+giAWXE/W5rtGEdMvnRAC/8j4yvU3S0iwahcH1Q=";
  };
} // (args.argsOverride or { }))
