{ alsaLib
, atk
, cairo
, cups
, curl
, dbus
, dpkg
, expat
, fetchurl
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gnome2
, gtk3
, krb5
, lib
, libX11
, libxcb
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
, libnotify
, libuuid
, lttng-ust
, libsecret
, nspr
, nss
, pango
, python37
, python37Packages
, stdenv
, systemd
, at-spi2-atk
, at-spi2-core
, autoPatchelfHook
, makeWrapper
, zlib
, icu
, openssl
, coreutils
, procps
, e2fsprogs
, iproute
, dnsmasq
, libappindicator-gtk3
}:
with stdenv.lib;
let
  deps = [ alsaLib at-spi2-atk at-spi2-core atk cairo cups curl dbus expat gdk-pixbuf glib gtk3 libuuid lttng-ust libsecret nspr nss pango python37 python37Packages.dbus-python libX11 libXScrnSaver libXcomposite libXcursor libXdamage libXext libXfixes libXi libXrandr libXrender libXtst libxcb stdenv.cc.cc libappindicator-gtk3 ];
  rpath = makeLibraryPath deps + ":${stdenv.cc.cc.lib}/lib64";
in
stdenv.mkDerivation rec {
  name = "appgate-sdp-${version}";
  version = "5.1.2";

  src = fetchurl {
    url = "https://bin.appgate-sdp.com/5.1/client/appgate-sdp_5.1.2_amd64.deb";
    sha256 = "0v4vfibg1giml3vfz2w7qypqzymvfchi5qm6vfagah2vfbkw7xc2";
  };
  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];
  dontConfigure = true;
  dontBuild = true;
  unpackPhase = ''
    dpkg-deb -x $src $out
  '';
  installPhase = ''
    mkdir -vp $out/bin
    ln -s "$out/opt/appgate/appgate" "$out/bin/appgate"
    cp -r $out/usr/share $out/share

    substituteInPlace $out/opt/appgate/linux/appgate-resolver.pre --replace "cat" "${coreutils}/bin/cat"
    substituteInPlace $out/opt/appgate/linux/appgate-resolver.pre --replace "mv" "${coreutils}/bin/mv"
    substituteInPlace $out/opt/appgate/linux/appgate-resolver.pre --replace "pkill" "${procps}/bin/pkill"
    substituteInPlace $out/opt/appgate/linux/appgate-resolver.pre --replace "chattr" "${e2fsprogs}/bin/chattr"
    substituteInPlace $out/opt/appgate/linux/appgate-dumb-resolver.pre --replace "cat" "${coreutils}/bin/cat"
    substituteInPlace $out/opt/appgate/linux/appgate-dumb-resolver.pre --replace "mv" "${coreutils}/bin/mv"
    substituteInPlace $out/opt/appgate/linux/appgate-dumb-resolver.pre --replace "pkill" "${procps}/bin/pkill"
    substituteInPlace $out/opt/appgate/linux/appgate-dumb-resolver.pre --replace "chattr" "${e2fsprogs}/bin/chattr"
    substituteInPlace $out/opt/appgate/linux/nm.py --replace "/usr/sbin/dnsmasq" "${dnsmasq}/bin/dnsmasq"
    substituteInPlace $out/opt/appgate/linux/set_dns --replace "service appgate-resolver stop" "${systemd.out}/bin/systemctl stop appgate-resolver"
    substituteInPlace $out/opt/appgate/linux/set_dns --replace "/etc/appgate.conf" "$out/etc/appgate.conf"
    substituteInPlace $out/etc/appgate.conf --replace "Info" "Debug"
  '';
  buildInputs = [ deps ];
  dontAutoPatchelf = true;

  enableParallelBuilding = true;
  runtimeDependencies = [ (lib.getLib systemd) libnotify libappindicator-gtk3 ];
  releaseName = name;
  postFixup = ''
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/libhostfxr.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/libmscordbi.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/libhostpolicy.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/libfido2.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/libcoreclr.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/libclrjit.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/libmscordaccore.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64:${lttng-ust}/lib" $out/opt/appgate/service/libcoreclrtraceptprovider.so
    patchelf --set-rpath "$out/opt/appgate/service:${glib.out}/lib:${libsecret.out}/lib:${libxcb}/lib:${libX11}/lib" $out/opt/appgate/service/libcredentialstorage.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64:${libxcb}/lib:${libX11}/lib" $out/opt/appgate/service/libshim.so
    patchelf --set-rpath "$out/opt/appgate/service:${stdenv.cc.cc.lib}/lib64:${libxcb}/lib:${libX11}/lib" $out/opt/appgate/service/libdbgshim.so
    patchelf --set-rpath "${libxcb}/lib:${libX11}/lib" $out/opt/appgate/libGLESv2.so
    patchelf --set-rpath "$out/opt/appgate/service:${krb5.out}/lib" $out/opt/appgate/service/System.Net.Security.Native.so
    patchelf --set-rpath "$out/opt/appgate/service:${zlib.out}/lib" $out/opt/appgate/service/System.IO.Compression.Native.so
    patchelf --set-rpath "$out/opt/appgate/service:${curl.out}/lib" $out/opt/appgate/service/System.Net.Http.Native.so
    patchelf --set-rpath "$out/opt/appgate/service:${systemd.out}/lib:${icu.out}/lib:${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/System.Globalization.Native.so
    patchelf --set-rpath "$out/opt/appgate/service:${openssl.out}/lib" $out/opt/appgate/service/System.Security.Cryptography.Native.OpenSsl.so
    patchelf --set-rpath "$out/opt/appgate/service:${zlib.out}/lib:${libsecret.out}/lib" $out/opt/appgate/service/libMonoPosixHelper.so

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${openssl.out}/lib:${rpath}:$out/opt/appgate:${systemd.out}/lib" $out/opt/appgate/appgate-driver
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${openssl.out}/lib:${rpath}:$out/opt/appgate:${systemd.out}/lib" $out/opt/appgate/appgate
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${stdenv.cc.cc.lib}/lib64" $out/opt/appgate/service/createdump
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${openssl.out}/lib:${icu.out}/lib:${dbus.out}/lib:${systemd.out}/lib:${stdenv.cc.cc.lib}/lib64:$out/opt/appgate/service" $out/opt/appgate/service/appgateservice.bin

    wrapProgram $out/opt/appgate/linux/set_dns --set PYTHONPATH $PYTHONPATH
  '';

  meta = with stdenv.lib; {
    description = "Appgate SDP (Software Defined Perimeter) desktop client";
    homepage = https://www.appgate.com/support/software-defined-perimeter-support;
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ "me@example.org" ];
  };
}
