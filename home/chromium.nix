{ pkgs, ...}:
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override({
      enableVaapi = true;
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-gpu-rasterization --ignore-gpu-blocklist --enable-zero-copy --disable-gpu-driver-bug-workarounds --enable-accelerated-video-decode";
    });
    extensions = [
      { id = "opldbaajfdlmdiililehillijmbdbhob"; } #gocleary
      { id = "gcbommkclmclpchllfjekcdonpmejbdp"; } #https
      { id = "hdokiejnpimakedhajhdlcegeplioahd"; } #lastpass
      { id = "glnpjglilkicbckjpbgcfkogebgllemb"; } #okta
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } #ublockorigin
    ];
  };
}
