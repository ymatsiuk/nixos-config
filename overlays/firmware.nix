{ firmwareLinuxNonfree
, fetchgit
}:
firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
  version = "main";
  outputHash = "sha256-NSPyINzt5N+Wk0F5ftVE11Kj7LLhF3TpRfQ29qd4lCE=";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "182a186c570baab3968ca9116ee58b1875fb0168";
    sha256 = "sha256-W/HsMnAIfCqm5XUPsPZ53dBCh/uNAlGfPEBRwmW9ZG0=";
  };
})
