{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc2";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  kernelPatches = [ ];
  # structuredExtraConfig = with lib.kernel; {
  #   DEBUG_LIST = yes;
  #   SOFTLOCKUP_DETECTOR = yes;
  #   HARDLOCKUP_DETECTOR = yes;
  #   DETECT_HUNG_TASK = yes;
  #   WQ_WATCHDOG = yes;
  #   CIFS_WEAK_PW_HASH = lib.mkForce (option no);
  # };
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "de9a03c2007f3c69c5fa86ef007841a4a9194aac";
    sha256 = "sha256-a3M+yFo8z1ET5tpaiTj+SmOrJiheRJY3Uky5KjqtWpA=";
  };
} // (args.argsOverride or { }))
