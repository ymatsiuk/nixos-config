{ pkgs, ... }:

let
  source = map (source: "source ${source}") [
    "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    "${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/git.zsh"
    "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/git/git.plugin.zsh"
  ];
  plugins = builtins.concatStringsSep "\n" (source);
in
{
  programs.zsh = {
    autosuggestions.enable = true;
    enable = true;
    enableCompletion = true;
    histSize = 10000;
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
      # keybindings for zsh-autosuggestions
      bindkey '^[[1;5C' forward-word # CTRL >
      bindkey '^[[1;5D' backward-word # CTRL <
    '';
    promptInit = ''
      which starship >/dev/null && eval "$(starship init zsh)"
      which zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"
      which atuin >/dev/null && eval "$(atuin init zsh --disable-up-arrow)"
    '';
    shellAliases = {
      ls = "${pkgs.eza}/bin/eza --group-directories-first";
      tree = "${pkgs.eza}/bin/eza --tree";
      k = "kubectl";
      ks = "kubectl -n kube-system";
      # kube decode secrets (mind the space in the end to separate ' from '' :facepalm.nix:)
      kds = ''kubectl get secrets -o go-template='{{range $k,$v := .data}}{{$k}}="{{($v | base64decode)}}"{{"\n"}}{{end}}' '';
      # kube get pods' images
      kgpi = ''kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" | tr -s '[[:space:]]' '\n' | sort | uniq -c'';
      tf = "terraform";
    };
  };
}
