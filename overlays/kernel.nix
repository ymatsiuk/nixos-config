{ lib, fetchgit, buildLinux, ... } @ args:
buildLinux (args // rec {
  version = "5.16-rc6";
  modDirVersion = builtins.replaceStrings [ "-" ] [ ".0-" ] version;
  extraMeta.branch = lib.versions.majorMinor version;
  src = fetchgit {
    url = "git://anongit.freedesktop.org/drm-tip";
    rev = "348c868d115c18195f5cf5b7a53b6f1370eab954";
    sha256 = "sha256-Ztz/YiWZM/EEnOJRj3HQjz6UxDz5O01/Ao0EHaeoab4=";
  };
} // (args.argsOverride or { }))
