#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"
bashRcDir="${HOME}/.bashrc.d"
bashRcFile="${bashRcDir}/git-chord.bashrc"

mkdir -p "$bashRcDir"
if [ -f "$bashRcFile" ]; then
    echo "Bashrc file with the same name is already exist (${bashRcFile}), removing..."
    if ! rm "$bashRcFile" > /dev/null 2>&1; then
        echo "Failed to remove existing bashrc file, exiting." >&2
        exit 1
    fi
fi
if ! touch "$bashRcFile" > /dev/null 2>&1; then
    echo "Failed to create bashrc file, exiting." >&2
    exit 1
fi
echo "PATH=\"\$PATH:${projectRootDir}/bin\"" > "$bashRcFile"
echo "Installation via bashrc was successful (${bashRcFile})."
