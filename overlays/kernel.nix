{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc3";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "909bf926eaf382123d9b215871143d9e3cf44aa3";
    sha256 = "sha256-SzJXa51mztY5OIi+WnooTduRLIukpuNzzVjBRVcOF9w=";
  };
} // (args.argsOverride or { }))
