{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "kubebuilder";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = "kubebuilder";
    rev = "v${version}";
    sha256 = "sha256-yPgg3IdBvE8gMFgXpHmYVcXtYWYAoHIeNFTRy4RzhS4=";
  };

  vendorSha256 = "sha256-lpyU6FYsv0ZjCQLhis1zVCkvdonZZWKU5FrqCUpqvn8=";

  subPackages = [ "cmd" ];

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X main.kubeBuilderVersion=${version}
      -X main.gitCommit=${src.rev}
      -X main.buildDate=1970-01-01
  '';

  postInstall = ''
    mv $out/bin/cmd $out/bin/kubebuilder
    for shell in bash fish zsh; do
      $out/bin/kubebuilder completion $shell > kubebuilder.$shell
      installShellCompletion kubebuilder.$shell
    done
  '';

  meta = with lib; {
    description = "Kubebuilder is a framework for building Kubernetes APIs using custom resource definitions (CRDs)";
    homepage = "https://github.com/kubernetes-sigs/kubebuilder";
    license = licenses.asl20;
    maintainers = with maintainers; [ ymatsiuk ];
  };
}

