{ pkgs, ... }:

{
  users = {
    mutableUsers = false;
    users = {
      ymatsiuk = {
        description = "Yurii Matsiuk";
        extraGroups = [ "ymatsiuk" "wheel" "audio" "video" "networkmanager" ];
        shell = pkgs.zsh;
        home = "/home/ymatsiuk";
        isNormalUser = true;
        uid = 1000;
        hashedPassword = "$6$qKPriFgsR5Qi$LusDW9UOXt0DylMTL6K7D7N63Ol7KCZwLBd8kF5dD7W28N2jnSfWxwDZCvES1z7Sa1wCRgzkweMnyuAMo5kec.";
        packages = with pkgs ; [
          aws-vault
          awscli2
          capitaine-cursors #sway/gtk dep
          exa
          firefox
          fd
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
          kubectl
          kubernetes-helm
          kustomize
          lastpass-cli
          nixpkgs-fmt
          openssl
          packer
          podman
          procps
          pulseaudio #i3status-rust dep
          ripgrep
          slackWayland
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

          gopls
          rnix-lsp
          nodePackages.pyright
          nodePackages.bash-language-server
          rubyPackages.solargraph
          terraform-ls
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

