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
    userEmail = "24990891+ymatsiuk@users.noreply.github.com";
    signing.key = "~/.ssh/github.pub";
    signing.signByDefault = true;
    includes = [
      {
        condition = "gitdir:~/git/gitlab/";
        contents.user = {
          email = "3461170-ymatsiuk@users.noreply.gitlab.com";
          signingKey = "~/.ssh/gitlab.pub";
        };
      }
      {
        condition = "gitdir:~/git/lightspeed*/";
        contents.user = {
          email = "yurii.matsiuk@lightspeedhq.com";
          signingKey = "~/.ssh/lightspeedhq.pub";
        };
      }
      {
        condition = "gitdir:~/git/nuorder/";
        contents.user = {
          email = "yurii.matsiuk@lightspeedhq.com";
          signingKey = "~/.ssh/nuorder.pub";
        };
      }
      {
        condition = "gitdir:~/git/shopkeep/";
        contents.user = {
          email = "yurii.matsiuk@lightspeedhq.com";
          signingKey = "~/.ssh/lightspeedhq.pub";
        };
      }
    ];

    extraConfig = {
      credential.helper = "lastpass";
      fetch.prune = true;
      init.defaultBranch = "main";
      pull.rebase = false;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers"; #manual
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
