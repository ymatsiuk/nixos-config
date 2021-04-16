{
  programs.qutebrowser = {
    enable = true;
    settings = {
      spellcheck.languages = [ "en-US" ];
    };
    keyBindings.normal.",m" = "hint links spawn mpv {hint-url}";
    keyBindings.normal.",c" = "hint links spawn firefox {hint-url}";
  };
}
