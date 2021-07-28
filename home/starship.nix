{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      hostname.ssh_only = false;
      line_break.disabled = true;
      username.format = "[$user]($style) at ";
      username.show_always = true;
    };
  };
}
