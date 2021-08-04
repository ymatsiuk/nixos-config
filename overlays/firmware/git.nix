{ stdenvNoCC, fetchgit, lib }:
stdenvNoCC.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "master";
  src = fetchgit {
    # the only source of QuZ-a0-hr-b0-64.ucode searchable in the Internet
    url = "https://chromium.googlesource.com/chromiumos/third_party/linux-firmware";
    rev = "710e4894f8dcba0fa21bf3a02dac2a8b6c0b4139";
    sha256 = "sha256-30ka5bHn7E4FN1GW2ljpZKc06ug2X4B1+weCiLOWKGQ=";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-6FfD1amjsl11dQbwURk7hZ9IrFaog2jT74QB69fMuZs=";
}
