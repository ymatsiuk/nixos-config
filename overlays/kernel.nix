{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc7";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "d3afb4b29c853809a5857b39eaed2be1eaf753fa";
    sha256 = "sha256-8EVoQ7FdpyiabZ6b2DphU6WeMaEnZnpcWuVCBUoJgHA=";
  };
} // (args.argsOverride or { }))
