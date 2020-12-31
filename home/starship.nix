let
  unstable = import <nixos-unstable> {};
in
{
  programs.starship = {
    enable = true;
    package = unstable.starship;
    settings = {
      add_newline = false;
      line_break.disabled = true;
      hostname.ssh_only = false;
      username.show_always = true;
    };
  };
}
