{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.14-rc4";
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
    rev = "2d9829863be1dc238b3094e0d41e5a3694efe193";
    sha256 = "sha256-z2/6Pvip7rbrS9Vq1WUOmatsvl90dxurBfpofckmBr8=";
  };
} // (args.argsOverride or { }))
