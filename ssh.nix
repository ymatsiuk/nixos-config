{
  # need this for legacy cisco infra
  programs.ssh = {
    kexAlgorithms = [
      "diffie-hellman-group1-sha1"
      "diffie-hellman-group-exchange-sha256"
      "diffie-hellman-group14-sha1"
    ];
  };
}
