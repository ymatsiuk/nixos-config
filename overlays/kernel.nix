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
    rev = "ba551d92d19db25d085cde572852bf6c08c7e750";
    sha256 = "sha256-yQwkL3ZgwTIc0uYt7cGNX3e3KuIw0zIhQMYhFziresk=";
  };
} // (args.argsOverride or { }))
