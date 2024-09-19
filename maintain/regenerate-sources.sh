#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"
maintainDir="${projectRootDir}/maintain"

"${maintainDir}/gen-README.md.sh" > "${projectRootDir}/README.md"
