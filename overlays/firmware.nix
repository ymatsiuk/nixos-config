{ stdenvNoCC, fetchgit, lib }:
stdenvNoCC.mkDerivation rec {
  pname = "chromiumos-firmware-linux-nonfree";
  version = "master";
  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/third_party/linux-firmware";
    rev = "4db10cd09c61ce9aabcc56d2532701a20e8cecc8";
    sha256 = "sha256-fIfwpfxYdKULJ6C+G3koVa7Oipr0MtKVH7b08Co7qzc=";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-UOP+KOIMgp/Wp3/1RPWxFW6Wl7/2KR2XtCEk6Cxp8t8=";
}
