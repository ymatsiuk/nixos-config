self: super:
{
  fetchFromSourcehut = super.callPackage ./fetchsrht { };
  dlm = super.callPackage ./dlm { };
  greetd = super.callPackage ./greetd { };
  gtkgreet = super.callPackage ./gtkgreet { };
  tuigreet = super.callPackage ./tuigreet { };
  wlgreet = super.callPackage ./wlgreet { };

  libfprint-tod = super.callPackage ./libfprint-tod { };
  libfprint-2-tod1-goodix = super.callPackage ./libfprint-2-tod1-goodix { };

  howdy = super.callPackage ./howdy { };
  pam_python = super.callPackage ./pam_python { };

  firmwareLinuxNonfree = super.callPackage ./firmware-linux-nonfree { };
}