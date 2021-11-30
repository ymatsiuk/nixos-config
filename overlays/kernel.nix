{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc3";
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
    rev = "a45a9993b4633973f97a4b981ceeb23e4b0963f9";
    sha256 = "sha256-3kupewh27sjBO1GziqmjvREcWZ5IUEhaQJMxLND0URU=";
  };
} // (args.argsOverride or { }))
