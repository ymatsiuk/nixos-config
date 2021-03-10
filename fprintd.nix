{ pkgs, ... }:
{
  services.fprintd = {
    enable = true;
    package = pkgs.fprintd.override {
      libfprint = pkgs.libfprint-tod;
    };
  };
  systemd.services.fprintd.environment = {
    FP_TOD_DRIVERS_DIR = "${pkgs.libfprint-2-tod1-goodix}/usr/lib/libfprint-2/tod-1";
  };
}
