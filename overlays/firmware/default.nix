{ firmwareLinuxNonfree
, fetchgit
}:
firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
  version = "2021-05-18";
  outputHash = "sha256-3BH22//C2ZQxQX7fUezYuoWm0qf8rAshUXfbxq+/KtU=";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "f8462923ed8fc874f770b8c6dfad49d39b381f14";
    sha256 = "sha256-//Gv3TRM7dAE0gVpEuPchcTOBHb9VKTKyF8HlhKqmw0=";
  };
})
