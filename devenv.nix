{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.woodpecker-cli
  ];

  env.WOODPECKER_PLUGINS_TRUSTED_CLONE = "woodpeckerci/plugin-git-simen";

  scripts.build.exec = ''
    docker buildx build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --platform linux/arm64 --output type=docker \
  --file docker/Dockerfile.multiarch --tag woodpeckerci/plugin-git-simen:latest .
  '';

  scripts.run.exec = ''
    docker run --rm \
  -v /Users/simen/Documents/gitverify/gitverify.json:/go/src/github.com/supply-chain-tools/gitverify/gitverify.json:ro \
  -e CI_REPO_CLONE_URL=https://github.com/supply-chain-tools/gitverify.git \
  -e CI_WORKSPACE=/go/src/github.com/supply-chain-tools/gitverify \
  -e CI_PIPELINE_EVENT=push \
  -e CI_COMMIT_SHA=be16911ec9be03df303206bd85e621308b1c4975 \
  -e CI_COMMIT_BRANCH=main \
  -e PLUGIN_REF=refs/heads/main \
  -e PLUGIN_DEPTH=0 \
  -e PLUGIN_PARTIAL=false \
  woodpeckerci/plugin-git-simen
  '';

  scripts.build-run.exec = ''
    build && \
    echo "-------------------------------------------------------------------" && \
    run
  '';

  languages.go.enable = true;

  enterShell = ''
    git --version # Use packages
  '';

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  # git-hooks.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
