{ firmwareLinuxNonfree
, fetchgit
}:
firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
  version = "main";
  outputHash = "sha256-Xm9QSrDZOli585YvJPEtQThDxUx88Mykyv5tdoXa7Xw=";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "13dca280f76009ba2c5f25408543a1aaaa062c25";
    sha256 = "sha256-THnf5oWAFh5thCKoKH/kZcO0VU8QDETorG2xR51fmTk=";
  };
})
