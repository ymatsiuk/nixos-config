{ stdenv
, lib
, libfprint
, fetchFromGitLab
}:

# for the curious, "tod" means "Touch OEM Drivers" meaning it can load
# external .so's.
libfprint.overrideAttrs ({ ... }: rec {
  pname = "libfprint-tod";
  version = "1.90.6+tod1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "3v1n0";
    repo = "libfprint";
    rev = "v${version}";
    sha256 = "185y54ylsqmi5vfjxi4sbl3gbwb3f8i1s0wppsnzcghnbjlckdyr";
  };

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/3v1n0/libfprint";
    description = "A library designed to make it easy to add support for consumer fingerprint readers, with support for loaded drivers";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ grahamc ];
  };
})

