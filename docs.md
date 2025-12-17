---
name: Gitverify Clone
icon: https://raw.githubusercontent.com/woodpecker-ci/plugin-git/main/git.svg
description: A fork of the official git clone plugin implementing gitverify to verify git commits.
author: simen64
tags: [git, clone, check, security]
containerImage: ghcr.io/simen64/gitverify-clone
containerImageUrl: https://ghcr.io/simen64/gitverify-clone
url: https://github.com/simen64/gitverify-clone
---

# plugin-git

This is an alternative to the default clone plugin that introduces verifying og git commits using [gitverify](github.com/supply-chain-tools/gitverify).
Its purpose is to secure your woodpecker pipeline from supply-chain attacks.

## Setup

You have to define this as your `DEFAULT_CLONE_PLUGIN` and have it be the only plugin in `WOODPECKER_PLUGINS_TRUSTED_CLONE`

You will still have to define it in your pipeline so you can mount in your `gitverify.json` to `/etc/gitverify.json`

```yaml
clone:
  git:
    image: ghcr.io/simen64/gitverify-clone
    volumes:
      - /etc/gitverify.json:/etc/gitverify.json:ro
```

## Overriding Settings

I support most of the settings from the official clone plugin with the exception of `submodules`, `depth`, and `partial`.
Consult [the `clone` section of the pipeline documentation][workflowClone] for the settings of the official plugin;

```yaml
clone:
  git:
    image: ghcr.io/simen64/gitverify-clone
    volumes:
      - /etc/gitverify.json:/etc/gitverify.json:ro
    settings:
      branch: master
      attempts: 10
```

## Settings

| Settings Name             | Default                             | Description                                                                                                                                                                |
| ------------------------- | ----------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `lfs`                     | `true`                              | Set this to `false` to disable retrieval of LFS files                                                                                                                      |
| `recursive`               | `false`                             | Clones submodules recursively                                                                                                                                              |
| `skip-verify`             | `false`                             | Skips the SSL verification                                                                                                                                                 |
| `tags`                    | `false` (except on tag event)       | Fetches tags when set to true, default is false if event is not tag else true                                                                                              |
| `submodule-override`      | _none_                              | Override submodule urls                                                                                                                                                    |
| `submodule-update-remote` | `false`                             | Pass the --remote flag to git submodule update                                                                                                                             |
| `submodule-partial`       | `true`                              | Update submodules via partial clone (depth=1)                                                                                                                              |
| `custom-ssl-path`         | _none_                              | Set path to custom cert                                                                                                                                                    |
| `custom-ssl-url`          | _none_                              | Set url to custom cert                                                                                                                                                     |
| `backoff`                 | `5sec`                              | Change backoff duration                                                                                                                                                    |
| `attempts`                | `5`                                 | Change backoff attempts                                                                                                                                                    |
| `branch`                  | $CI_COMMIT_BRANCH                   | Change branch name to checkout to                                                                                                                                          |
| `home`                    |                                     | Change HOME var for commands executed, fail if it does not exist                                                                                                           |
| `remote`                  | $CI_REPO_CLONE_URL                  | Set the git remote url                                                                                                                                                     |
| `remote-ssh`              | $CI_REPO_CLONE_SSH_URL              | Set the git SSH remote url                                                                                                                                                 |
| `object-format`           | detected from commit SHA            | Set the object format for Git initialization. Supported values: `sha1`, `sha256`.                                                                                          |
| `sha`                     | $CI_COMMIT_SHA                      | git commit hash to retrieve                                                                                                                                                |
| `ref`                     | _none_                              | Set the git reference to retrieve                                                                                                                                          |
| `path`                    | $CI_WORKSPACE                       | Set destination path to clone to                                                                                                                                           |
| `use-ssh`                 | `false`                             | Clone using SSH                                                                                                                                                            |
| `ssh-key`                 | _none_                              | path to SSH key for SSH clone                                                                                                                                              |
| `merge-pull-request`      | `false`                             | merge the pull request with the target branch (can fail on merge conflict)                                                                                                 |
| `fetch-target-branch`     | `false`                             | fetch the target branch without merging (useful for tools like nx affected that need both branches locally)                                                                |
| `target-branch`           | $CI_COMMIT_TARGET_BRANCH            | Target branch used when merging pull requests (`merge-pull-request`) or when fetching the target branch (`fetch-target-branch`)                                            |
| `git-user-name`           | _none_                              | Git username used when pull requests are used.                                                                                                                             |
| `git-user-email`          | _none_                              | Git email used when pull requests are used.                                                                                                                                |

[workflowClone]: https://woodpecker-ci.org/docs/usage/workflow-syntax#clone
