{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16.0";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "a8ae2fba8948946087ddc13ec6f4c44b6bcf3c72";
    sha256 = "sha256-mStFRuyOPHST8Pe++WUwGd39GRr0UUl+ur7bpSoX0+Y=";
  };
} // (args.argsOverride or { }))
