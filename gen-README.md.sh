#!/bin/sh

printf '%s' '# Git chord - repository state manager

## Introduction

TODO

## Installation

Currently no packaged version is available.
However, you can find two installer scripts in the `install` directory:

- `install-global-usrlocalbin.sh`: general global installer, requires root permission
- `install-user-bashrc-path.sh`: user-scope installer for bash environments,
   also installs bash autocompletion for the `git chord` subcommands and options
';

git chord help --verbose --markdown | sed -E 's/^`(\w+)`:/[`\1`](#git-chord-\1)/' | tail -n +2

git chord spec commands | while IFS=' ' read -r command subCommands; do
    git chord "$command" help --verbose --markdown | sed 's/^#/##/'
done
