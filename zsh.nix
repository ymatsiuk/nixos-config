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
    enableBashCompletion = true;
    enableCompletion = true;
    enableGlobalCompInit = true;
    histSize = 10000;
    syntaxHighlighting.enable = true;
    setOptions = [
      "autocd"
      "cdablevars"
      "histallowclobber"
      "histexpiredupsfirst"
      "histfcntllock"
      "histignorealldups"
      "histignoredups"
      "histignorespace"
      "histreduceblanks"
      "incappendhistory"
      "nomultios"
      "sharehistory"
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
      ls = "${pkgs.eza}/bin/eza --group-directories-first";
      tree = "${pkgs.eza}/bin/eza --tree";
      groot = "cd $(git rev-parse --show-toplevel)";
      k = "kubectl";
      ks = "kubectl -n kube-system";
      tf = "terraform";
      tg = "terragrunt";
      on-gh-token = "export GITHUB_TOKEN=$(rbw get https://github.com)";
      off-gh-token = "unset GITHUB_TOKEN";
      sit = "${pkgs.idasen-cli}/bin/idasen-cli restore sit";
      stand = "${pkgs.idasen-cli}/bin/idasen-cli restore stand";
      vpn-staging = "${pkgs.awsvpnclient}/bin/awsvpnclient start --config ~/.config/awsvpn/staging.ovpn";
      vpn-production = "${pkgs.awsvpnclient}/bin/awsvpnclient start --config ~/.config/awsvpn/production.ovpn";
    };
  };
}
