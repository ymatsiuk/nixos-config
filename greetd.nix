{ pkgs, lib, ... }:
let
  waylandEnablement = pkgs.writeShellScript "wayland-enablement" ''
    export MOZ_ENABLE_WAYLAND=1
    export CLUTTER_BACKEND=wayland
    export QT_QPA_PLATFORM=wayland-egl
    export ECORE_EVAS_ENGINE=wayland-egl
    export ELM_ENGINE=wayland_egl
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export NO_AT_BRIDGE=1
  '';
  swayRun = pkgs.writeShellScript "sway-run" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway

    source ${waylandEnablement}

    exec ${pkgs.systemd}/bin/systemd-cat --identifier=sway ${pkgs.sway}/bin/sway --debug $@
  '';
in
{
  imports =
    [
      ./modules/greetd.nix
    ];

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
