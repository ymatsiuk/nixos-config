{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16.0";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "78b8a3e2f4543ecf92fe5a59dbd0255503c97dcc";
    sha256 = "sha256-tpO46yY38e5Cm2TCoNy2G9XVvIFR+wZm4Zv2KqGZy/U=";
  };
} // (args.argsOverride or { }))
