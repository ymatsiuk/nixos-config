{ pkgs, ... }:

{
  users = {
    mutableUsers = false;
    users = {
      ymatsiuk = {
        description = "Yurii Matsiuk";
        extraGroups = [ "ymatsiuk" "wheel" "audio" "video" "networkmanager" "docker" ];
        shell = pkgs.zsh;
        home = "/home/ymatsiuk";
        isNormalUser = true;
        uid = 1000;
        hashedPassword = "$6$qKPriFgsR5Qi$LusDW9UOXt0DylMTL6K7D7N63Ol7KCZwLBd8kF5dD7W28N2jnSfWxwDZCvES1z7Sa1wCRgzkweMnyuAMo5kec.";
        packages = with pkgs ; [
          aws-vault
          awscli2
          bluejeans-gui
          capitaine-cursors #sway/gtk dep
          dogdns
          eksctl
          exa
          fluxcd
          gitAndTools.gh
          gitAndTools.git-remote-codecommit #AWS codeCommit
          gnumake
          go
          iw #i3status-rust dep
          jq
          kubectl
          kubernetes-helm
          kustomize
          lastpass-cli
          lf
          libnotify
          lm_sensors #i3status-rust dep
          nixpkgs-fmt
          pulseaudio #i3status-rust dep
          ripgrep
          ssm-session-manager-plugin
          teleport-ent
          terraform_0_13
          wdisplays #sway dep
          wev #sway dep
          wf-recorder #sway
          wl-clipboard #sway dep
          zoom-us
        ];
      };
    };
    groups = {
      ymatsiuk = {
        gid = 1000;
        members = [ "ymatsiuk" ];
      };
    };
  };
}

