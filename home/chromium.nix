{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override ({
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
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
