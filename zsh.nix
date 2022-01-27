{ pkgs, ... }:

let
  source = map (source: "source ${source}") [
    "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
    "${pkgs.fzf}/share/fzf/completion.zsh"
    "${pkgs.fzf}/share/fzf/key-bindings.zsh"
    "${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/git.zsh"
    "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/git/git.plugin.zsh"
  ];
  plugins = builtins.concatStringsSep "\n" (source);
in
{
  programs.zsh = {
    autosuggestions.async = true;
    autosuggestions.enable = true;
    enable = true;
    enableCompletion = true;
    enableGlobalCompInit = true;
    histSize = 10000;
    syntaxHighlighting.enable = true;
    setOptions = [
      "extendedglob"
      "incappendhistory"
      "sharehistory"
      "histignoredups"
      "histignorealldups"
      "histignorespace"
      "histexpiredupsfirst"
      "histfcntllock"
      "histreduceblanks"
      "histallowclobber"
      "autocd"
      "cdablevars"
      "nomultios"
    ];
    interactiveShellInit = ''
      export KEYTIMEOUT=1
      ${plugins}
      bindkey -v
      zstyle ':completion:*' menu select
      zstyle ':completion:*' insert-tab false
      # keybindings for zsh-history-substring-search
      bindkey "$terminfo[kcuu1]" history-substring-search-up
      bindkey "$terminfo[kcud1]" history-substring-search-down
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down
    '';
    promptInit = ''
      which starship >/dev/null && eval "$(starship init zsh)"
    '';
    shellAliases = {
      ls = "${pkgs.exa}/bin/exa --group-directories-first";
      tree = "${pkgs.exa}/bin/exa --tree";
      flexpass = "${pkgs.libsecret}/bin/secret-tool lookup lpass flexport | ${pkgs.wl-clipboard}/bin/wl-copy --paste-once --trim-newline";
      ympass = "${pkgs.libsecret}/bin/secret-tool lookup lpass personal | ${pkgs.wl-clipboard}/bin/wl-copy --paste-once --trim-newline";
      on-gh-token = "export GITHUB_TOKEN=`${pkgs.lastpass-cli}/bin/lpass show --pass github.com`";
      off-gh-token = "unset GITHUB_TOKEN";
      on-pd-token = "export PAGERDUTY_TOKEN=`${pkgs.lastpass-cli}/bin/lpass show --note PD_TOKEN`";
      off-pd-token = "unset PAGERDUTY_TOKEN";
      nixdev = "${pkgs.nixUnstable}/bin/nix develop github:ymatsiuk/nixos-config -c zsh";
    };
  };
}
