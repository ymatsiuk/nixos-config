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
    CIFS_WEAK_PW_HASH = lib.mkForce (option no);
  };
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "7006e15e0a109ce092026c4b576fe8a206e8b756";
    sha256 = "sha256-4eqE7QIoh066okBwT0Ch/tDKA+L5F5O7+6QMwhXBzrg=";
  };
} // (args.argsOverride or { }))
