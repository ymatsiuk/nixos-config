let
  secrets = import ../secrets.nix;
in
{
  programs.rbw = {
    enable = true;
    settings = {
      email = secrets.rbw.email;
      lock_timeout = 86400;
      sync_interval = 600;
      pinentry = "curses";
    };
  };
}
