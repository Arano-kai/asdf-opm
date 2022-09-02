<div align="center">

# asdf-opm [![Build](https://github.com/Arano-kai/asdf-opm/actions/workflows/build.yml/badge.svg)](https://github.com/Arano-kai/asdf-opm/actions/workflows/build.yml) [![Lint](https://github.com/Arano-kai/asdf-opm/actions/workflows/lint.yml/badge.svg)](https://github.com/Arano-kai/asdf-opm/actions/workflows/lint.yml)


[opm](https://github.com/operator-framework/operator-registry/blob/master/docs/design/opm-tooling.md) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add opm
# or
asdf plugin add opm https://github.com/Arano-kai/asdf-opm.git
```

opm:

```shell
# Show all installable versions
asdf list-all opm

# Install specific version
asdf install opm latest

# Set a version globally (on your ~/.tool-versions file)
asdf global opm latest

# Now opm commands are available
opm --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/Arano-kai/asdf-opm/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Arano-kai](https://github.com/Arano-kai/)
