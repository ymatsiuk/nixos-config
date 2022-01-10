{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16.0";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "1d8aba1cfbab48b322c4d464437dd0c34da468ec";
    sha256 = "sha256-jt8sPPM00Qzqg/WoxMm3C/C1OU7lSTHiTY9a+PSXJQc=";
  };
} // (args.argsOverride or { }))
