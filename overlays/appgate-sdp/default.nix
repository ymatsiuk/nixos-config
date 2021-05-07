{ alsaLib
, autoPatchelfHook
, at-spi2-atk
, at-spi2-core
, atk
, bash
, cairo
, coreutils
, cups
, curl
, dbus
, dnsmasq
, dpkg
, e2fsprogs
, expat
, fetchurl
, gdk-pixbuf
, glib
, gtk3
, icu
, iproute2
, krb5
, lib
, mesa
, libdrm
, libX11
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libxkbcommon
, libsecret
, libuuid
, libxcb
, lttng-ust
, makeWrapper
, networkmanager
, nspr
, nss
, openssl
, pango
, procps
, python37
, python37Packages
, stdenv
, systemd
, xdg-utils
, zlib
}:
with lib;
let
  deps = [
    alsaLib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    icu
    krb5
    mesa
    libdrm
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxkbcommon
    libsecret
    libuuid
    libxcb
    lttng-ust
    nspr
    nss
    openssl
    pango
    stdenv.cc.cc
    systemd
    zlib
  ];
in
stdenv.mkDerivation rec {
  pname = "appgate-sdp";
  version = "5.4.0";

  src = fetchurl {
    url = "https://bin.appgate-sdp.com/${versions.majorMinor version}/client/appgate-sdp_${version}_amd64.deb";
    sha256 = "sha256-2DzZ5JnFGBeaHtDf7CAXb/qv6kVI+sYMW5Nc25E3eNA=";
  };

  # just patch interpreter
  autoPatchelfIgnoreMissingDeps = true;
  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    python37
    python37Packages.dbus-python
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  installPhase = ''
    cp -r $out/usr/share $out/share

    substituteInPlace $out/lib/systemd/system/appgate-dumb-resolver.service \
        --replace "/opt/" "$out/opt/"

    substituteInPlace $out/lib/systemd/system/appgatedriver.service \
        --replace "/opt/" "$out/opt/" \
        --replace "InaccessiblePaths=/mnt /srv /boot /media" "InaccessiblePaths=-/mnt -/srv -/boot -/media"

    substituteInPlace $out/lib/systemd/system/appgate-resolver.service \
        --replace "/usr/sbin/dnsmasq" "${dnsmasq}/bin/dnsmasq" \
        --replace "/opt/" "$out/opt/"

    substituteInPlace $out/opt/appgate/linux/nm.py \
        --replace "/usr/sbin/dnsmasq" "${dnsmasq}/bin/dnsmasq"

    substituteInPlace $out/opt/appgate/linux/set_dns \
        --replace "/etc/appgate.conf" "$out/etc/appgate.conf"

    wrapProgram $out/opt/appgate/service/createdump \
        --set LD_LIBRARY_PATH "${makeLibraryPath [ stdenv.cc.cc ]}"

    wrapProgram $out/opt/appgate/appgate-driver \
        --prefix PATH : ${makeBinPath [ iproute2 networkmanager dnsmasq ]} \
        --set LD_LIBRARY_PATH $out/opt/appgate/service

    makeWrapper $out/opt/appgate/Appgate $out/bin/appgate \
        --prefix PATH : ${makeBinPath [ xdg-utils ]} \
        --set LD_LIBRARY_PATH $out/opt/appgate:${makeLibraryPath deps}

    wrapProgram $out/opt/appgate/linux/set_dns --set PYTHONPATH $PYTHONPATH
  '';

  meta = with lib; {
    description = "Appgate SDP (Software Defined Perimeter) desktop client";
    homepage = "https://www.appgate.com/support/software-defined-perimeter-support";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ymatsiuk ];
  };
}
