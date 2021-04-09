self: super:
{
  libfprint-2-tod1-goodix = super.libfprint-2-tod1-goodix.overrideAttrs (
    oldAttrs: rec {
      passthru.driverPath = "/usr/lib/libfprint-2/tod-1";
    }
  );

  howdy = super.callPackage ./howdy { };
  pam_python = super.callPackage ./pam_python { };
}
