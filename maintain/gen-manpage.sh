#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"
genDocPartCommand="${projectRootDir}/maintain/gen-doc-part.md.sh"

{
    "$genDocPartCommand" manhelp
    printf '%s\n\n' "# DESCRIPTION OF SUBCOMMANDS"
    "$genDocPartCommand" subcommands
} | pandoc -f markdown -t man --standalone
