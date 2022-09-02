# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test opm https://github.com/Arano-kai/asdf-opm.git "opm --help"
```

Tests are automatically run in GitHub Actions on push and PR.
