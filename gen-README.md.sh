#!/bin/sh

printf '%s' '# Git chord - repository state manager

## Introduction

TODO

## Installation

The simplest way to install git-chord is using the netinstaller:

```shell
curl -s https://raw.githubusercontent.com/davidsusu/git-chord/main/install/netinstall-user.sh | sh
```

This will clone the source repository to the `git-chord` directory in the home directory,
and execute the bashrc based per-user intaller.

If you want to install it manually, you can use one of the installer scripts
can be found the `install` directory:

- `install-global-usrlocalbin.sh`: general global installer, requires root permission
- `install-user-bashrc-path.sh`: user-scope installer for bash environments,
   also installs bash autocompletion for the `git chord` subcommands and options
- `netinstall-user.sh`: netinstaller script, clones the repository, and install the extension

Currently no packaged version is available.
';

git chord help --verbose --markdown | sed -E 's/^`(\w+)`:/[`\1`](#git-chord-\1)/' | tail -n +2

git chord spec commands | while IFS=' ' read -r command subCommands; do
    git chord "$command" help --verbose --markdown | sed 's/^#/##/'
done
