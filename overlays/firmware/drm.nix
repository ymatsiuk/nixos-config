{ stdenvNoCC, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "drm-firmware";
  version = "guc_v62_huc_7_9";
  src = builtins.fetchGit {
    url = "git://anongit.freedesktop.org/drm/drm-firmware";
    ref = "guc_62.0_huc_7.9";
    rev = "f4d897acd200190350a5f2148316c51c6c57bc9b";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-U2flMiVSIsjh3xVI1pNO8SP0eCDF9quZWnUl8l1SN/k=";
}

