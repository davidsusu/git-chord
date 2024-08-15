#!/bin/sh

projectRootDir="$( realpath "$( dirname -- "$( realpath "$0" )" )"/.. )"
installDir="/usr/local/bin"
targetPath="${installDir}/git-chord"

mkdir -p "$installDir"
if [ -f "$targetPath" ]; then
    echo "Command file with the same name is already exist (${targetPath}), removing..."
    if ! rm "$targetPath" > /dev/null 2>&1; then
        echo "Failed to remove existing command file, exiting." >&2
        exit 1
    fi
fi
if \
    sudo mkdir -p "$installDir" &&
    sudo cp "${projectRootDir}/bin/git-chord" "${installDir}/" &&
    sudo chmod +x "$targetPath"
then
    echo "Global command installation was successful (${targetPath})."
else
    echo "Failed to install git-chord command, exiting." >&2
    exit 1
fi
