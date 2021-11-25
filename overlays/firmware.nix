{ firmwareLinuxNonfree
, fetchgit
}:
firmwareLinuxNonfree.overrideAttrs (oldAttrs: rec {
  version = "main";
  outputHash = "sha256-7OoOZbBTVKt89PvzhVjrAdG2a8L+H6YttDou+VVY5kY=";
  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git";
    rev = "b0e898fbaf377c99a36aac6fdeb7250003648ca4";
    sha256 = "sha256-xYLJFXBZHmGIm+BgEbbK3SMwZHplbBMqAvD5QNGLwWU=";
  };
})
