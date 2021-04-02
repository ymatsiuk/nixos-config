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
        defaultText = "pkgs.fprintd and if tod.enable=`true` then pkgs.fprintd-tod";
        description = ''
          fprintd package to use.
        '';
      };

      tod = {

        enable = mkEnableOption "Touch OEM Drivers library support";

        driver = mkOption {
          type = types.package;
          default = pkgs.libfprint-2-tod1-goodix;
          defaultText = "pkgs.libfprint-2-tod1-goodix";
          description = ''
            Touch OEM Drivers (TOD) package to use.
          '';
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
      FP_TOD_DRIVERS_DIR = "${cfg.tod.driver}${cfg.tod.driver.driverPath}";
    };

  };

}
