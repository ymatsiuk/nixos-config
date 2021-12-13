{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc5";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "6f01ceb604c3f28565301ee1f4755231cad2e6cb";
    sha256 = "sha256-EnDLZGyvKqnlojMk3A45bjdHk320Z9E1ALJfWyEAarM=";
  };
} // (args.argsOverride or { }))
