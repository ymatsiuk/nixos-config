{ stdenvNoCC, fetchgit, lib }:
stdenvNoCC.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "master";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "b7c134f0d3491113958276d631b4e69771a6c5be";
    sha256 = "sha256-xk6tbmMrHWBsX6kjOCDs6v0Eslq10b0bW7Bi4bCyt6A=";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-C6pcR2Zo0h7K5JgfIZmeE01hm9Ufy+tkjPtSLyQEhzw=";
}
