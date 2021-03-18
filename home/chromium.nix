{ pkgs, ...}:
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override({
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --flag-switches-begin --enable-gpu-rasterization --enable-zero-copy --ignore-gpu-blocklist --enable-features=UseOzonePlatform,NativeNotifications,VaapiVideoDecoder,Vulkan,WebRTCPipeWireCapturer --flag-switches-end";
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
