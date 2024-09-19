#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"

manDirectory="${HOME}/.local/share/man"
man1Directory="${manDirectory}/man1"
mkdir -p "$man1Directory"
manFilePath="${man1Directory}/git-chord.1.gz"
echo "Install manpage to ${manFilePath}"
"${projectRootDir}/maintain/gen-manpage.sh" | gzip > "$manFilePath"
