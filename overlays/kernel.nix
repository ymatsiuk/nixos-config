{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc3";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "7be12d9fc88471b17b9c3df25215834928258b65";
    sha256 = "sha256-8Zsn6P2RAEkGRwvHOjdlNoMhDQWZc8mHwzRJTzomh+g=";
  };
} // (args.argsOverride or { }))
