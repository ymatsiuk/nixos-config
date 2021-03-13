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
          capitaine-cursors #sway/gtk dep
          dmenu-wayland #sway dep
          dogdns
          eksctl
          exa
          fluxcd
          gitAndTools.gh
          gitAndTools.git-remote-codecommit #AWS codeCommit
          gnumake
          go
          gsimplecal #i3status-rust dep
          iw #i3status-rust dep
          jq
          kubectl
          kubernetes-helm
          kustomize
          lastpass-cli
          lf
          libsecret #alias dep
          lm_sensors #i3status-rust dep
          neofetch
          pulseaudio #i3status-rust dep
          pavucontrol #i3status-rust dep
          ripgrep
          ssm-session-manager-plugin
          sway-contrib.grimshot #sway dep
          swayidle #sway dep
          swaylock #sway dep
          teleport
          terraform_0_13
          wdisplays #sway dep
          wev #sway dep
          wf-recorder #sway
          wl-clipboard #sway dep
          xdg-utils #appgate dep
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

