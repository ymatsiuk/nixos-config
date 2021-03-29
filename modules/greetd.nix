{ config, lib, pkgs, ... }:
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
  environment.etc = {
    "greetd/config.toml".text = ''
      [terminal]
      vt = 7

      [default_session]
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${swayRun}"
      user = "greeter"

      [initial_session]
      command = "${swayRun}"
      user = "ymatsiuk"
    '';
  };

  systemd.services.display-manager = lib.mkForce {
    enable = lib.mkForce true;
    description = "Greetd";
    wantedBy = [ "multi-user.target" ];
    wants = [ "systemd-user-sessions.service" ];
    after = [
      "systemd-user-sessions.service"
    ];
    aliases = [ "greetd.service" ];
    serviceConfig = {
      ExecStart = lib.mkForce "${pkgs.greetd.greetd}/bin/greetd";
      IgnoreSIGPIPE = "no";
      SendSIGHUP = "yes";
      TimeoutStopSec = "30s";
      KeyringMode = "shared";
      StartLimitBurst = lib.mkForce "5";
    };

    startLimitIntervalSec = 30;
    restartTriggers = lib.mkForce [ ];
    restartIfChanged = false;
    stopIfChanged = false;
  };

  users.users.greeter.isSystemUser = true;

  security.pam.services.greetd = {
    allowNullPassword = true;
    startSession = true;
    enableGnomeKeyring = true;
  };
}
