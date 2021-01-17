{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      # git_status  -  634ms <-- facepalm.rs
      git_status.disabled = false;
      hostname.ssh_only = false;
      line_break.disabled = true;
      username.show_always = true;
    };
  };
}
