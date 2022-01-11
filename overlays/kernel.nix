{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16.0";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "d7878bca9dadc036e0edf005bbb48e4c3d617d96";
    sha256 = "sha256-zgBhBIazOMl/6zJUqA5O482SpoPhtyUlPlAgN+D0jM4=";
  };
} // (args.argsOverride or { }))
