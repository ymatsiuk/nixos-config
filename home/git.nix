let
  secrets = import ../secrets.nix;
in
{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      side-by-side = true;
      syntax-theme = "none";
    };
  };

  programs.git = {
    enable = true;

    signing = {
      format = "ssh";
      key = "~/.ssh/github.pub";
      signByDefault = true;
    };
    includes = [
      {
        condition = "gitdir:~/git/gitlab/";
        contents.user = {
          email = "3461170-ymatsiuk@users.noreply.gitlab.com";
          signingKey = "~/.ssh/gitlab.pub";
        };
      }
      {
        condition = "gitdir:~/git/geophy/";
        contents.user = {
          email = secrets.git.geophy.email;
          signingKey = "~/.ssh/geophy.pub";
        };
      }
    ];
    settings = {
      user = {
        name = "Yurii Matsiuk";
        email = "24990891+ymatsiuk@users.noreply.github.com";
        signingKey = "~/.ssh/github.pub";
      };

      branch.sort = "-committerdate";
      commit.verbose = true;
      credential = {
        helper = "!f() { test \"$1\" = get && while read -r line; do case $line in protocol=*) protocol=\${line#*=} ;; host=*) host=\${line#*=} ;; username=*) user=\${line#*=} ;; esac done && test \"$protocol\" = \"https\" && test -n \"$host\" && token=$(rbw get \"$host\" \"$user\") && printf 'password=%s\n' \"$token\"; }; f";
        username = "ymatsiuk";
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers"; # manual -> echo "$(git config --get user.email) namespaces=\"git\" $(cat ~/.ssh/<MY_KEY>.pub)" >> ~/.ssh/allowed_signers
      rebase = {
        autoStash = true;
        autoSquash = true;
        updateRefs = true;
        abbreviateCommands = true;
        missingCommitsCheck = "warn";
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      tag.sort = "version:refname";
      url."https://github.com/".insteadOf = [
        "gh:"
        "github:"
      ];
    };
  };
}
