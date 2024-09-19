#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"
genDocPartCommand="${projectRootDir}/maintain/gen-doc-part.md.sh"

"$genDocPartCommand" general
"$genDocPartCommand" help
"$genDocPartCommand" subcommands
