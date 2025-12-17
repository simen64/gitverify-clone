# plugin-git

⚠️ This is a WIP and is in no way stable yet ⚠️

*Hopefully a similar implementation will be able to be upstreamed*

Fork of the official woodpecker git-clone plugin used to clone git repositories with gitverify implemented to verify
git commits. See [`docs.md` in this repository](docs.md) for usage and options

## Build

Build the binary with the following command:

```console
export GOOS=linux
export GOARCH=amd64
export CGO_ENABLED=0
export GO111MODULE=on

go build -v -a -tags netgo -o release/linux/amd64/plugin-gitverify-clone
```

## Docker

Build the Docker image with the following command:

```console
docker buildx build \
  --label org.label-schema.build-date=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
  --label org.label-schema.vcs-ref=$(git rev-parse --short HEAD) \
  --platform linux/arm64 --output type=docker \
  --file docker/Dockerfile.multiarch --tag gitverify-clone:latest .
```

*The platform linux/amd64 should be replaced by the correct platform.*

This will build the image and load it into docker so the image can be used locally.
[More information on the output formats can be found in docker buildx doc](https://docs.docker.com/engine/reference/commandline/buildx_build/#output).

If using nix devenv you can use the `build` script for building the docker image.

## Usage

Clone a commit:

```console
  docker run --rm \
    -v /Users/simen/Documents/gitverify/gitverify.json:/go/src/github.com/supply-chain-tools/gitverify/gitverify.json:ro \
    -e CI_REPO_CLONE_URL=https://github.com/supply-chain-tools/gitverify.git \
    -e CI_PIPELINE_EVENT=push \
    -e CI_COMMIT_SHA=be16911ec9be03df303206bd85e621308b1c4975 \
    -e CI_COMMIT_BRANCH=main \
    -e PLUGIN_REF=refs/heads/main \
    -e PLUGIN_DEPTH=0 \
    -e PLUGIN_PARTIAL=false \
    gitverify-clone

```

## Build arguments

### HOME

The docker image can be build using `--build-arg HOME=<custom home>`.
This will create the directory for the custom home and set the custom home as the default value for the `home` plugin setting (see [the plugin docs](./docs.md) for more information about this setting).
