#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"

"${projectRootDir}/maintain/regenerate-sources.sh"
