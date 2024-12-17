{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
      kubernetes = {
        disabled = false;
        contexts = [
          {
            context_pattern = "arn:aws:eks:(?P<region>[\\w-]+):(?P<account_id>[\\d]+):cluster/(?P<cluster>[\\w-]+)";
            context_alias = "$cluster";
            style = "green";
          }
        ];
      };
    };
  };
}
