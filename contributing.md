# Contributing

Commits are welcome, do not hesitate to make one (:

This repo use git-flow workflow, please make push requests to `develop` branch.

Most conventional way to do this are:
  1. Fork this repo.
  2. Clone locally and make `feature/name_as_you_want` branch
  3. Hack and push to your fork to able to test your improvements
  4. One of the following:
      - Install plugin from your fork:
        ```shell
        $ asdf plugin add opm-fork <fork_url>
        $ asdf plugin update opm-fork feature/name_as_you_want
        ```
        Do update part after each push.
        Also, instead `opm-fork` you can choose any plugin name, even `opm`,
        justh ensure that original plugin uninstalled before.
      - Or just issue in-place build-in test:
        ```shell
        asdf plugin test opm <fork_url> [--asdf-tool-version <version>] --asdf-plugin-gitref feature/name_as_you_want "opm --help"
        ```
  5. After you satisfied, make push request to upstream repo.
      To get merged, all tests must pass.
      Tests are automatically run in GitHub Actions on push and PR.
