{ slack
, lib
, autoPatchelfHook
, xdg-utils
, forceWayland ? false
, enablePipewire ? false
}:
slack.overrideAttrs (oldAttrs: {
  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ autoPatchelfHook ];
  autoPatchelfIgnoreMissingDeps = true;
  dontUnpack = false;
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
      --prefix LD_LIBRARY_PATH : "$out/lib:${oldAttrs.rpath}" \
      --add-flags "--logLevel=error" \
      --add-flags "${lib.optionalString enablePipewire "--enable-features=WebRTCPipeWireCapturer"}${lib.optionalString forceWayland ",UseOzonePlatform"}" \
      --add-flags "${lib.optionalString forceWayland "--ozone-platform=wayland"}" \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
      --prefix PATH : ${lib.makeBinPath [xdg-utils]}

    # Fix the desktop link
    substituteInPlace $out/share/applications/slack.desktop \
      --replace /usr/bin/ $out/bin/ \
      --replace /usr/share/ $out/share/

    runHook postInstall
  '';
})
