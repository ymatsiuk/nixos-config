{ stdenvNoCC, fetchgit, lib }:
stdenvNoCC.mkDerivation rec {
  pname = "chromiumos-firmware-linux-nonfree";
  version = "master";
  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/third_party/linux-firmware";
    rev = "44c379f0966963cbcddb18986bd8cbf689919984";
    sha256 = "sha256-uB7QQTzhrrsjCeT2fFyxlq2uqt90x9nHenu9Tm8sK/E=";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-H4aPrlexCx5Sggg8gnhAb9+9GtAkv1GS1A1uhnZhqcg=";
}
