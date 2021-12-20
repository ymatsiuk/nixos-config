{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc5";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "c4f095f24fcdc6e85ae112052b3034328e24ae66";
    sha256 = "sha256-oZwZ6IeggtK1/iebPtWK99VwjA0wCcQET3yDBcXl374=";
  };
} // (args.argsOverride or { }))
