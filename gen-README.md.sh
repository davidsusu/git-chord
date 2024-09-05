#!/bin/sh

printf '%s' '# Git chord - repository state manager

## Introduction

TODO
';

git chord help --verbose --markdown | sed -E 's/^`(\w+)`:/[`\1`](#git-chord-\1)/' | tail -n +2

git chord spec commands | while IFS=' ' read -r command subCommands; do
    git chord "$command" help --verbose --markdown | sed 's/^#/##/'
done
