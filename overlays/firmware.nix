{ firmwareLinuxNonfree
, fetchgit
}:
firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
  version = "main";
  outputHash = "sha256-F/si6w9wLBrHCfx6tczOg7u29CO/OqxepZmuPpKcJrc=";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "f682ecb015df087613f91872712eb6c0f6c998a8";
    sha256 = "sha256-52TTfLhqlxqjLuRmFgpVERCkesPXlFhIgUG/fVe60jU=";
  };
})
