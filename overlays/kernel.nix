{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc5";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "c638e6957221626098fab621a4774b77b933dff2";
    sha256 = "sha256-4IqWfBKX+G4mG3hGwuK96ygQAbgkGPVI5fWPBk4NbPY=";
  };
} // (args.argsOverride or { }))
