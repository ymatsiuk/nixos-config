{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16.0";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "31b826a55fd46e5e2fc21720a466946f9ccfe557";
    sha256 = "sha256-wSdEP555LwF5Udn0mSjeyFLITY/Etmm+cKNsBHxP8iM=";
  };
} // (args.argsOverride or { }))
