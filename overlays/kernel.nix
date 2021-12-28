{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc7";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "6ff0b924d73f6fa1f08bef4fce0f7342b2523c72";
    sha256 = "sha256-3jbq2WIOVSbf4rg2ZngfkRg4msNsT9vPh8r+OtPOppM=";
  };
} // (args.argsOverride or { }))
