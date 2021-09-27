{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.15-rc3";
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
    CIFS_WEAK_PW_HASH = lib.mkForce (option no);
  };
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "ea28c76e2817bbaf31c243973dac23ed6c280946";
    sha256 = "sha256-XsFTSpp11VWssoz58yzE12AJ5RBco81SMbxkeiglWaE=";
  };
} // (args.argsOverride or { }))
