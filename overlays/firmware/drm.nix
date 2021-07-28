{ stdenvNoCC, lib }:

stdenvNoCC.mkDerivation rec {
  pname = "drm-firmware";
  version = "tgl_rkl_dmc_updates";
  src = builtins.fetchGit {
    url = "git://anongit.freedesktop.org/drm/drm-firmware";
    ref = "tgl_rkl_dmc_updates";
    rev = "2ea630c8f25625abbf96e8f59a454d06e3b5c851";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-guVhfg6cNCdabE4lFav8JwZ0kT4KdKOJMKA+gO4eoLg=";
}
