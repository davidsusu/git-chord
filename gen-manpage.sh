#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"

# TODO: make the manpage more standard

"${projectRootDir}/gen-README.md.sh" | pandoc -f markdown -t man --standalone
