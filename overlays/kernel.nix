{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc6";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "11804f70759de195d5994299c6bef58fd0c869b2";
    sha256 = "sha256-3lD+J2yTYnuPf512aHu3LqDnxCTpEvd9QSMjEb4L9Xo=";
  };
} // (args.argsOverride or { }))
