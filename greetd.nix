{ pkgs, lib, ... }:
let
  waylandEnablement = pkgs.writeShellScript "wayland-enablement" ''
    export MOZ_ENABLE_WAYLAND=1
  '';
  swayRun = pkgs.writeShellScript "sway-run" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway

    source ${waylandEnablement}

    ${pkgs.systemd}/bin/systemd-run --user --scope --collect --quiet --unit=sway-$(${pkgs.systemd}/bin/systemd-id128 new) ${pkgs.systemd}/bin/systemd-cat --identifier=sway ${pkgs.sway}/bin/sway $@
  '';
in
{
  services.greetd = {
    enable = true;
    restart = false;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${swayRun}";
        user = "greeter";
      };
      initial_session = {
        command = "${swayRun}";
        user = "ymatsiuk";
      };
    };
  };
}
