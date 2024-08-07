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
      # kube decode secrets (mind the space in the end to separate ' from '' :facepalm.nix:)
      kds = ''kubectl get secrets -o go-template='{{range $k,$v := .data}}{{$k}}="{{($v | base64decode)}}"{{"\n"}}{{end}}' '';
      # kube get pods' images
      kgpi = ''kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c'';
      tf = "terraform";
      tg = "terragrunt";
    };
  };
}
