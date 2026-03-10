# Useful commands for Git

Here are some useful extra commands that you can install and call from
Git.

- `git-delete-gone-branches` will delete branches where the remote
  branch is gone (that is, deleted). This happen when you create a PR
  on GitHub in your own remote branch, merge it with an upstream
  branch, and then delete the branch. This is the normal working
  pattern for most GitHub users, so it is useful to have a command to
  clean up a repository.
