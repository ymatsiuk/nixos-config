{
  programs.qutebrowser = {
    enable = true;
    extraConfig = "config.load_autoconfig()";
    keyBindings = {
      normal = {
        ",m" = "hint links spawn mpv --hwdec=auto {hint-url}";
      };
    };
  };
}
