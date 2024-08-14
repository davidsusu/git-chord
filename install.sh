#!/bin/sh

selfDir="$( dirname -- "$( realpath "$0" )" )"

bashRcDir="${HOME}/.bashrc.d"
if [ -d "$bashRcDir" ]; then
    bashRcFile="${bashRcDir}/git-chord.bashrc"
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
    echo 'PATH="$PATH:'"$selfDir"'/bin"' > "$bashRcFile"
    echo "Installation via bashrc was successful (${bashRcFile})."
else
    installDir="/usr/local/bin"
    targetPath="${installDir}/git-chord"
    if [ -f "$targetPath" ]; then
        echo "Command file with the same name is already exist (${targetPath}), removing..."
        if ! rm "$targetPath" > /dev/null 2>&1; then
            echo "Failed to remove existing command file, exiting." >&2
            exit 1
        fi
    fi
    if \
        sudo mkdir -p "$installDir" &&
        sudo cp "${selfDir}/bin/git-chord" "${installDir}/" &&
        sudo chmod +x "$targetPath"
    then
        echo "Global command installation was successful (${targetPath})."
    else
        echo "Failed to install git-chord command, exiting." >&2
        exit 1
    fi
fi
