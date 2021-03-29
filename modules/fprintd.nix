{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.fprintd;
  fprintdPkg = if cfg.tod.enable then pkgs.fprintd-tod else pkgs.fprintd;

in
{

  ###### interface

  options = {

    services.fprintd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable fprintd daemon and PAM module for fingerprint readers handling.
        '';
      };

      package = mkOption {
        type = types.package;
        default = fprintdPkg;
        defaultText =
          "pkgs.fprintd and if tod.enable=`true` then pkgs.fprintd-tod";
        description = ''
          fprintd package to use.
        '';
      };

      tod = {

        enable = mkEnableOption "Touch OEM Drivers library support";

        driver = {

          package = mkOption {
            type = types.package;
            default = pkgs.libfprint-2-tod1-goodix;
            defaultText = "pkgs.libfprint-2-tod1-goodix";
            description = ''
              TOD package to use.
            '';
          };

          path = mkOption {
            type = types.nullOr types.path;
            description = ''
              The path to TOD directory containing the driver
            '';
            default = "/usr/lib/libfprint-2/tod-1";
            defaultText = "/usr/lib/libfprint-2/tod-1";
            example = literalExample "/usr/lib/libfprint-2/tod-1";
          };
        };
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    services.dbus.packages = [ fprintdPkg ];

    environment.systemPackages = [ fprintdPkg ];

    systemd.packages = [ fprintdPkg ];

    systemd.services.fprintd.environment = mkIf cfg.tod.enable {
      FP_TOD_DRIVERS_DIR = "${cfg.tod.driver.package}${cfg.tod.driver.path}";
    };
  };
}
