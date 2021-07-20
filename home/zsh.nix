{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "viins";
    history = {
      extended = true;
      path = ".config/zsh/zsh_history";
    };
    dotDir = ".config/zsh";
    shellAliases = {
      vi = "${pkgs.neovim}/bin/nvim";
      vim = "${pkgs.neovim}/bin/nvim";
      ls = "${pkgs.exa}/bin/exa --group-directories-first";
      tree = "${pkgs.exa}/bin/exa --tree";
      flexpass = "${pkgs.libsecret}/bin/secret-tool lookup lpass flexport | ${pkgs.wl-clipboard}/bin/wl-copy --paste-once --trim-newline";
      ympass = "${pkgs.libsecret}/bin/secret-tool lookup lpass personal | ${pkgs.wl-clipboard}/bin/wl-copy --paste-once --trim-newline";
      on-gh-token = "export GITHUB_TOKEN=`${pkgs.lastpass-cli}/bin/lpass show --pass github.com`";
      off-gh-token = "unset GITHUB_TOKEN";
      on-personal-pd-token = "export PAGERDUTY_TOKEN=`${pkgs.lastpass-cli}/bin/lpass show --note PD_TOKEN_PERSONAL`";
      off-personal-pd-token = "unset PAGERDUTY_TOKEN";
      on-pd-token = "export PAGERDUTY_TOKEN=`${pkgs.lastpass-cli}/bin/lpass show --note PD_TOKEN`";
      off-pd-token = "unset PAGERDUTY_TOKEN";
      nixdev = "${pkgs.nixUnstable}/bin/nix develop github:ymatsiuk/nixos-config -c zsh";
    };
    zplug = {
      enable = true;
      plugins = [
        {
          name = "zsh-users/zsh-history-substring-search";
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = [ "defer:2" ];
        }
        {
          name = "lib/git";
          tags = [ "from:oh-my-zsh" ];
        }
        {
          name = "plugins/git";
          tags = [ "from:oh-my-zsh" ];
        }
      ];
    };
    initExtra = with pkgs; ''
      export KEYTIMEOUT=1

      ZSH_AUTOSUGGEST_USE_ASYNC=1
      ZSH_AUTOSUGGEST_STRATEGY=(history completion)

      zmodload zsh/complist
      zstyle ':completion:*' menu select
      zstyle ':completion:*' insert-tab false
      # bindkey '^I' first-tab-completion
      bindkey -M menuselect '\e' send-break
      bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
      bindkey -M menuselect 'h' vi-backward-char
      bindkey -M menuselect 'k' vi-up-line-or-history
      bindkey -M menuselect 'l' vi-forward-char
      bindkey -M menuselect 'j' vi-down-line-or-history

      setopt HIST_FIND_NO_DUPS
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down

      setopt extendedglob
    '';
  };
}
