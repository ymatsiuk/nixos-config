{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.14-rc3";
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
    rev = "76112b9dedfa1943354f58fc3fc028203e6fe96b";
    sha256 = "sha256-EWT3836Rh4mZ+TSjdU495ZH4Eau7sdUvVBiC18SKvgc=";
  };
} // (args.argsOverride or { }))
