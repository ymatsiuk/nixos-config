{
  programs.git = {
    enable = true;
    # delta.enable = true;
    defaultProfile = "github";
    profiles = {
      github = {
        name = "Yurii Matsiuk";
        email = "ymatsiuk@users.noreply.github.com";
        signingKey = "61302290298601AA";
        dirs = [ "~/git/github/" "/etc/nixos/" ];
      };
      flexport = {
        name = "Yurii Matsiuk";
        email = "ymatsiuk@flexport.com";
        signingKey = "6E06F90BDC44D975";
        dirs = [ "~/git/flexport/" ];
      };
      ing = {
        name = "Yurii Matsiuk";
        email = "yurii.matsiuk@ing.com";
        signingKey = "0B95325581C4B57D";
        dirs = [ "~/git/yolt/" ];
      };
    };

    delta = {
      enable = true;
      options = {
        features = "side-by-side";
        syntax-theme = "none";
      };
    };

    signing = { signByDefault = true; };
    extraConfig = {
      pull = { rebase = false; };
      credential = { helper = "lastpass"; };
      rebase = {
        autoStash = true;
        autoSquash = true;
        abbreviateCommands = true;
        missingCommitsCheck = "warn";
      };
    };
  };
}
