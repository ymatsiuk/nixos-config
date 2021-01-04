{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      hostname.ssh_only = false;
      username.show_always = true;
    };
  };
}
