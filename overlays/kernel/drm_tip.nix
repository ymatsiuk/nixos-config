{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.14-rc5";
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
    rev = "7a2a60f961bd7bcc00aacb1d590a2b11ff2a93bd";
    sha256 = "sha256-YBZcaBVxPCk/QcuecW5eDe4ENwlKIG55lmhQD/Ro8B0=";
  };
} // (args.argsOverride or { }))
