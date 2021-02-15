{ pkgs, ... }:

{
  security.sudo.wheelNeedsPassword = false;
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
          light
          libsecret
          neofetch
          ripgrep
          ssm-session-manager-plugin
          teleport
          terraform_0_13
          xdg-utils #appgate dep

          pavucontrol

          bemenu
          grim
          swayidle
          swaylock
          wdisplays
          wev
          wl-clipboard
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

