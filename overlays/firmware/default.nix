{ firmwareLinuxNonfree
, fetchgit
}:
firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
  version = "2021-06-09";
  outputHash = "sha256-Sh4jFpz7h2bnmgeXiMM0Kzhk/vxnwIZzOF1M2v3ejUs=";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "0f66b74b6267fce66395316308d88b0535aa3df2";
    sha256 = "sha256-JSLxyf57x4czXZZQcowBlx6X+SK2MMXIoPLXfJIigAI=";
  };
})
