{ stdenvNoCC, fetchgit, lib }:
stdenvNoCC.mkDerivation rec {
  pname = "chromiumos-firmware-linux-nonfree";
  version = "master";
  src = fetchgit {
    url = "https://chromium.googlesource.com/chromiumos/third_party/linux-firmware";
    rev = "c9d3bcd57565947b40df3b6372dad69d4009c929";
    sha256 = "sha256-2Baae62PD9U8KyRF4m12W0uiTZzx8KNqcDZ3/Gjkv48=";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-vN1fv7WD5Vn5vJiZXR9NdAks3h41YMM9hr5PI/KT4+A=";
}

