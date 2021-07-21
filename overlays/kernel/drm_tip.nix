{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.14-rc2";
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
    rev = "eac5f37741ad4cc0f6698bbae25734167c2a771b";
    sha256 = "sha256-IBn5yuI+4LeaSrjPOrBe77c09bNTin8QkiFir8G/yqM=";
  };
} // (args.argsOverride or { }))
