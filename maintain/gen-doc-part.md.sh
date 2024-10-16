#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"
chordDevCommand="${projectRootDir}/bin/git-chord"

partName="$1"

case "$partName" in
    general)
printf '%s' '# Git Chord - repository state manager

## Introduction

Git Chord is a git extension that adds the `chord` subcommand to git,
using which you can create, browse, manipulate, and share
snapshots of the state of a git repository.

It'"'"'s that easy to take a snapshot (using the default settings):

```shell
git chord snapshot
```

Alternatively, you can create a full snapshot which includes storing the state of all supported objects,
regardless of the current configuration:

```shell
git chord snapshot --fullstore
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
Git Chord is fully customizable via git config and ad hoc comand line options,
[see below for the available options](#options).

Git Chord is particularly suitable for the following situations:

- when there is a need for sharing a constellation of the branches, across the team
- when you want to snapshot the repository state before a complex sequence of git operations
- when students are expected to submit their work as an overall repository state
- when you want to use multiple branches to deploy and rollback service configurations
- when you want to memoize specific states of the repository and browse the history of these

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

## Configuration

Configuration management in Git Chord is multi-layered.
At the lowest level are the default settings, which can be listed using the following command:

```shell
git chord config --default
```

You can override these settings in the repository'"'"'s scope, for example as follows:

```shell
git chord config set stagingarea.store.enabled true
```

The overrides are stored in the standard git config store (using the `chord.` prefix).
You can list the repository scoped configuration in this way:

```shell
git chord config
```

For any command, it is possible to override the configuration ad hoc at the command line.
See below for a list of configuration options that can be overridden by command line options.
For the `snapshot` subcommand, the `--fullstore` option can be used to enable storing all supported state data of the repository,
this can be useful for full migrations and help requests.
Similarly, for the `apply` subcommand, the `--fullapply` option enables the application of all saved data.
A command with ad hoc configuration changes might look like:

```shell
git chord snapshot --fullstore --no-workingtree-store-enabled --annotatedtags-store-regex '"'"'v.*'"'"' full
```

Git Chord supports the creation and use of profiles. Profiles override some configuration values, to do this you need to use the xxx prefix in the configuration. When a profile is applied, the value on the key after the profile prefix is overwritten. To apply a profile, use the --profile option. The --profile option can be used multiple times, in which case the named profiles are applied in order. Here is an example of using profiles:

```shell
git chord list --profile profile1 --profile profile2 --all
```
';
        exit 0
        ;;
    help)
        "$chordDevCommand" help --verbose --markdown | tail -n +2 | sed -E 's/^`(\w+)`:/[`\1`](#git-chord-\1)/'
        exit 0
        ;;
    manhelp)
        printf '%s\n\n' "# NAME"
        printf '%s\n\n' "git-chord - git extension for managing snapshots of the state of a repository"
        "$chordDevCommand" help --verbose --markdown | tail -n +2 |
            sed -E 's/^##/#/; s/^# Usage:/# SYNOPSIS/' |
            awk '/^# \w.*:$/ { sub(/:$/, "", $0); print toupper($0); next }1' |
            sed -E 's/^# SUBCOMMANDS$/# DESCRIPTION\
\
Git chord is a git extension that adds the `chord` subcommand to git,\
using wich you can create, browse, manipulate, and share\
snapshots of the state of a git repository.\
\
&/' \
        ;
        exit 0
        ;;
    subcommands)
        "$chordDevCommand" spec commands | grep -E '^.' | while IFS=' ' read -r command subCommands; do
            git chord "$command" help --verbose --markdown | sed -E 's/^#/##/'
        done
        exit 0
        ;;
esac
