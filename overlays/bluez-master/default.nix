{ bluez, fetchFromGitHub, autoconf, automake, libtool }:

bluez.overrideAttrs (oldAttrs: rec {
  version = "master";
  src = fetchFromGitHub {
    owner = "bluez";
    repo = "bluez";
    rev = "2af9ef2fa0a3aee7bbeb7fd2c10205dd5fcfd2d3";
    sha256 = "sha256-Z0KcYF0RMn/R/RBH7/5+c4wj0TnblZI/UASS25AtcTs=";
  };
  buildInputs = oldAttrs.buildInputs ++ [ autoconf automake libtool ];
  preConfigure = ''
    ./bootstrap
  '';
  configureFlags = [
    "--localstatedir=/var"
    "--enable-library"
    "--enable-cups"
    "--enable-pie"
    "--with-dbusconfdir=${placeholder "out"}/share"
    "--with-dbussystembusdir=${placeholder "out"}/share/dbus-1/system-services"
    "--with-dbussessionbusdir=${placeholder "out"}/share/dbus-1/services"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/etc/systemd/user"
    "--with-udevdir=${placeholder "out"}/lib/udev"
    "--enable-health"
    "--enable-midi"
    "--enable-nfc"
    "--enable-sap"
    "--enable-sixaxis"
    "--enable-wiimote"
  ];
})
