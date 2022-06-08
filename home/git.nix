{
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        syntax-theme = "none";
      };
    };

    userName = "Yurii Matsiuk";
    userEmail = "ymatsiuk@users.noreply.github.com";
    signing.key = "61302290298601AA";
    signing.signByDefault = true;
    includes = [
      {
        condition = "gitdir:~/git/yolt/";
        contents.user = {
          email = "yurii.matsiuk@ing.com";
          signingKey = "0B95325581C4B57D";
        };
      }
      {
        condition = "gitdir:~/git/flexport/";
        contents.user = {
          email = "ymatsiuk@flexport.com";
          signingKey = "6E06F90BDC44D975";
        };
      }
    ];

    extraConfig = {
      credential.helper = "lastpass";
      fetch.prune = true;
      init.defaultBranch = "main";
      pull.rebase = false;
      rebase = {
        autoStash = true;
        autoSquash = true;
        abbreviateCommands = true;
        missingCommitsCheck = "warn";
      };
      url."https://github.com/".insteadOf = [ "gh:" "github:" ];
    };
  };
}
