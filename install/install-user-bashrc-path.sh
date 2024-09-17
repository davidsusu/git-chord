#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"
bashRcDir="${HOME}/.bashrc.d"
bashRcFile="${bashRcDir}/git-chord.bashrc"
completionSourceFile="${projectRootDir}/completion/git-chord-completion.bashrc"
completionBashRcFile="${bashRcDir}/git-chord-completion.bashrc"

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
printf '%s\n' "export PATH=\"\$PATH:${projectRootDir}/bin\"" > "$bashRcFile"

if [ -f "$completionBashRcFile" ]; then
    echo "Completion bashrc file with the same name is already exist (${bashRcFile}), removing..."
    if ! rm "$completionBashRcFile" > /dev/null 2>&1; then
        echo "Failed to remove existing completion bashrc file, exiting." >&2
        exit 1
    fi
fi
if ! ln -s "$completionSourceFile" "$completionBashRcFile" > /dev/null 2>&1; then
    echo "Failed to link completion bashrc file, exiting." >&2
    exit 1
fi

echo "Installation via bashrc was successful."
