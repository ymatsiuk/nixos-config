self: super:
{
  greetd = super.callPackage ./greetd { };
  tuigreet = super.callPackage ./tuigreet { };

  libfprint-tod = super.callPackage ./libfprint-tod { };
  fprintd-tod = super.callPackage ./fprintd { libfprint = self.libfprint-tod; };
  libfprint-2-tod1-goodix = super.callPackage ./libfprint-2-tod1-goodix { };

  howdy = super.callPackage ./howdy { };
  pam_python = super.callPackage ./pam_python { };

  firmwareLinuxNonfree = super.callPackage ./firmware-linux-nonfree { };
}
