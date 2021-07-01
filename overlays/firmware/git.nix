{ stdenvNoCC, fetchgit, lib }:
stdenvNoCC.mkDerivation rec {
  pname = "firmware-linux-nonfree";
  version = "master";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "d79c26779d459063b8052b7fe0a48bce4e08d0d9";
    sha256 = "sha256-ThsEpKjh3uBuXpWnkRvqH0p4WkkHimLUNXAC6Z8gBIU=";
  };
  installFlags = [ "DESTDIR=$(out)" ];
  dontFixup = true;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "sha256-d/TuDVsRi0URnoqYzJ89fTBpq9m3oxDYFs5pgzThzCo=";
}
