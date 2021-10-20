{ alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, autoPatchelfHook
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
, lib
, libGL
, libappindicator-gtk3
, libdrm
, libnotify
, libpulseaudio
, libuuid
, libxcb
, libxkbcommon
, libxshmfence
, makeWrapper
, mesa
, nodePackages
, nspr
, nss
, pango
, pipewire
, stdenv
, systemd
, undmg
, xdg-utils
, xorg
, forceWayland ? false
, enablePipewire ? false
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "slack";

  x86_64-darwin-version = "4.20.0";
  x86_64-darwin-sha256 = "1argl690i4dgz5ih02zg9v4zrlzm282wmibnc6p7xy5jisd5g79w";

  x86_64-linux-version = "4.20.0";
  x86_64-linux-sha256 = "1r8w8s3y74lh4klsmzq2d3f0h721b3a2b53nx8v7b0s6j8w0g0mh";

  aarch64-darwin-version = "4.20.0";
  aarch64-darwin-sha256 = "1argl690i4dgz5ih02zg9v4zrlzm282wmibnc6p7xy5jisd5g79w";

  version = {
    x86_64-darwin = x86_64-darwin-version;
    aarch64-darwin = aarch64-darwin-version;
    x86_64-linux = x86_64-linux-version;
  }.${system} or throwSystem;

  src =
    let
      base = "https://downloads.slack-edge.com";
    in
      {
        x86_64-darwin = fetchurl {
          url = "${base}/releases/macos/${version}/prod/x64/Slack-${version}-macOS.dmg";
          sha256 = x86_64-darwin-sha256;
        };
        aarch64-darwin = fetchurl {
          url = "${base}/releases/macos/${version}/prod/arm64/Slack-${version}-macOS.dmg";
          sha256 = aarch64-darwin-sha256;
        };
        x86_64-linux = fetchurl {
          url = "${base}/releases/linux/${version}/prod/x64/slack-desktop-${version}-amd64.deb";
          sha256 = x86_64-linux-sha256;
        };
      }.${system} or throwSystem;

  meta = with lib; {
    description = "Desktop client for Slack";
    homepage = "https://slack.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ mmahut ];
    platforms = [ "x86_64-darwin" "x86_64-linux" "aarch64-darwin" ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version src meta;

    passthru.updateScript = ./update.sh;

    rpath = lib.makeLibraryPath [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gnome2.GConf
      gtk3
      libGL
      libappindicator-gtk3
      libdrm
      libnotify
      libpulseaudio
      libuuid
      libxcb
      libxkbcommon
      mesa
      nspr
      nss
      pango
      pipewire
      stdenv.cc.cc
      systemd
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxkbfile
      xorg.libxshmfence
    ] + ":${stdenv.cc.cc.lib}/lib64";

    buildInputs = [
      gtk3 # needed for GSETTINGS_SCHEMAS_PATH
    ];

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
      makeWrapper
      nodePackages.asar
    ];

    autoPatchelfIgnoreMissingDeps = true;

    dontBuild = true;

    unpackPhase = ''
      # deb file contains a setuid binary, so 'dpkg -x' doesn't work here
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      mv usr/* $out/
      rm $out/bin/slack

      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix LD_LIBRARY_PATH : "$out/lib:${rpath}" \
        --add-flags "${lib.optionalString enablePipewire "--enable-features=WebRTCPipeWireCapturer"}${lib.optionalString forceWayland ",UseOzonePlatform --ozone-platform=wayland"}" \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [xdg-utils]}

      # Fix the desktop link
      substituteInPlace $out/share/applications/slack.desktop \
        --replace /usr/bin/ $out/bin/ \
        --replace /usr/share/ $out/share/

      runHook postInstall
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit pname version src meta;

    passthru.updateScript = ./update.sh;

    nativeBuildInputs = [ undmg ];

    sourceRoot = "Slack.app";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications/Slack.app
      cp -R . $out/Applications/Slack.app
      /usr/bin/defaults write com.tinyspeck.slackmacgap SlackNoAutoUpdates -bool YES
      runHook postInstall
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux

