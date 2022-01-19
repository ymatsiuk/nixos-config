{ firmwareLinuxNonfree
, fetchgit
}:
firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
  version = "main";
  outputHash = "sha256-VSyp0DJ0y6bf4ZtZ8HPcGnOq7F3RLmAKWsSo9NMlCGE=";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "1e744b85cd4ce4f9b2f2e6afabd6cb4058438541";
    sha256 = "sha256-k3rLXkzdcHLwwNvL4K46FrqxR3Kzj1NCcMJoYULYB9o=";
  };
})
