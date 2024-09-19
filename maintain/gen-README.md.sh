#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"
chordDevCommand="${projectRootDir}/bin/git-chord"

printf '%s' '# Git chord - repository state manager

## Introduction

Git chord is a git extension that adds the `chord` subcommand to git,
using wich you can create, browse, manipulate, and share
snapshots of the state of a git repository.

It'"'"'s that easy to take a snapshot (using the default settings):

```shell
git chord snapshot
```

And later you can restore the saved state:

```shell
git chord apply
```

Of course, you can save multiple snapshots, even on multiple tracker branches,
and you also have a freedom in applying any of them.

By default, a snapshot contains the status of all branches, annotated tags, and the HEAD.
By changing the settings, you can control, for example, which branches and tags should be saved,
and you can also require lightweight tags, dirty staging area, and dirty working tree to be saved.
Git chord is fully customizable via git config and ad hoc comand line options,
[see below for the available options](#options).

## Installation

The simplest way to install the git-chord command is using the netinstaller:

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

"$chordDevCommand" help --verbose --markdown | sed -E 's/^`(\w+)`:/[`\1`](#git-chord-\1)/' | tail -n +2

"$chordDevCommand" spec commands | while IFS=' ' read -r command subCommands; do
    git chord "$command" help --verbose --markdown | sed 's/^#/##/'
done
