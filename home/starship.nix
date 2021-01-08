{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      # git_status  -  634ms <-- facepalm.rs
      git_status.disabled = true;
      line_break.disabled = true;
      hostname.ssh_only = false;
      username.show_always = true;
    };
  };
}
