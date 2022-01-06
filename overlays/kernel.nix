{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc8";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "9b0d7ca3667904f5d5ba802c5d7c840db46de5f6";
    sha256 = "sha256-lvEn2mKMT8L8Qd8CZl9KTNwLvL+Hh/2ZFJWEjd9tgoA=";
  };
} // (args.argsOverride or { }))
