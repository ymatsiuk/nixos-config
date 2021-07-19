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
          docker-compose
          exa
          fluxcd
          gcc
          gitAndTools.gh
          gitAndTools.git-remote-codecommit #AWS codeCommit
          gnumake
          go
          golangci-lint
          iw #i3status-rust dep
          jq
          kind
          kubebuilder
          kubectl
          kubernetes-helm
          kustomize
          lastpass-cli
          lm_sensors #i3status-rust dep
          nixpkgs-fmt
          openssl
          packer
          procps
          pulseaudio #i3status-rust dep
          ripgrep
          slack
          ssm-session-manager-plugin
          teleport-ent.tctl
          teleport.client
          terraform
          vulkan-loader
          vulkan-tools
          vulkan-validation-layers
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

