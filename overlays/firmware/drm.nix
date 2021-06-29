{ stdenvNoCC, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "drm-firmware";
  version = "guc_v62";
  src = builtins.fetchGit {
    url = "git://anongit.freedesktop.org/drm/drm-firmware";
    ref = "guc_v62";
    rev = "5b20d5ead3692bf6cdf5b87dedc471391f5b9f1c";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-pl5wCveb3ht1+3lQ8bdK8p7lXTQvsKd+fGRyEGIXy+c=";
}

