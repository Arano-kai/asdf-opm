<div align="center">

# asdf-opm [![Build](https://github.com/Arano-kai/asdf-opm/actions/workflows/build.yml/badge.svg)](https://github.com/Arano-kai/asdf-opm/actions/workflows/build.yml) [![Lint](https://github.com/Arano-kai/asdf-opm/actions/workflows/lint.yml/badge.svg)](https://github.com/Arano-kai/asdf-opm/actions/workflows/lint.yml)


[opm][opm-docs] plugin for the [asdf version manager][asdf-vm].

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

The versions prefixed by `openshift-` are [distributed][ocp-flavor-opm-repo] by RedHat
and meant to use with corresponding [OKD][okd]/[OpenShift][ocp] ([OCP][ocp]) clusters.
The OCP version of OPM available from OpenShift v4.7.

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Why?

Mostly by personal needs -- have to maintain several OKD/OpenShift clusters with different versions in restricted networks.
The opm utility are required to [maintain OperatorHub catalog in disconnected environment](https://docs.okd.io/4.11/operators/admin/olm-restricted-networks.html).

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors][contributors]!

# License

See [LICENSE](LICENSE) © [Arano-kai](https://github.com/Arano-kai/)


[asdf-vm]: https://asdf-vm.com
[opm-docs]: https://github.com/operator-framework/operator-registry/blob/master/docs/design/opm-tooling.md
[contributors]: https://github.com/Arano-kai/asdf-opm/graphs/contributors
[okd]: https://www.okd.io/
[ocp]: https://www.redhat.com/en/technologies/cloud-computing/openshift/container-platform
[ocp-flavor-opm-repo]: https://mirror.openshift.com/pub/openshift-v4
