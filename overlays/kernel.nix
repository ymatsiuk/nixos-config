{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc4";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "e540b0c4da51fd576e9b61489899acd074a0e4cd";
    sha256 = "sha256-zgQEvQUJqIQWUGZ+avxiDo0jF6tQvHPVndvmaECtIK8=";
  };
} // (args.argsOverride or { }))
