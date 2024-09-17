#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"

"${projectRootDir}/gen-README.md.sh" | pandoc -f markdown -t man --standalone
