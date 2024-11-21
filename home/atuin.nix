{
  programs.atuin = {
    enable = true;
    flags = [ " --disable-up-arrow" ];
    settings = {
      style = "compact";
      inline_height = 15;
      history_filter = [
        "^(echo|cat).+base64.+"
        "^(rm|z|cd|ls|man|cat|grep|which|dmesg|uname) .*"
      ];
    };
  };
}
