{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16.0";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "fe44f8bdb12374a6168cb561834eb714097f5e5f";
    sha256 = "sha256-jgd1nPDi1MjmwMUwQqzDUTKYI7oYUnVv289C30ruggs=";
  };
} // (args.argsOverride or { }))
