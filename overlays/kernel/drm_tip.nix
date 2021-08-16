{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.14-rc6";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  kernelPatches = [ ];
  structuredExtraConfig = with lib.kernel; {
    DEBUG_LIST = yes;
    SOFTLOCKUP_DETECTOR = yes;
    HARDLOCKUP_DETECTOR = yes;
    DETECT_HUNG_TASK = yes;
    WQ_WATCHDOG = yes;
    IDE = lib.mkForce (option no);
  };
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "029f8ff4156268d7abc8acde2eddd3041c7a94e4";
    sha256 = "sha256-rOQlXVq1SdHU+IlHbrWAR55baRjgC6/Ivu88ylWAE1E=";
  };
} // (args.argsOverride or { }))
