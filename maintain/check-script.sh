#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"

shellcheck "${projectRootDir}/bin/git-chord"
