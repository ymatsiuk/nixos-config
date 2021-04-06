self: super:
{
  libfprint-2-tod1-goodix = super.callPackage ./libfprint-2-tod1-goodix { };

  howdy = super.callPackage ./howdy { };
  pam_python = super.callPackage ./pam_python { };
}
