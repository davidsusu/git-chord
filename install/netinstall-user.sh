#!/bin/sh

GIT_URL='https://github.com/davidsusu/git-chord'

startDir="$( realpath "$( pwd )" )"
installDir="${HOME}/git-chord"
mkdir -p "$installDir"

cd "$installDir"

git clone "$GIT_URL" .

# TODO: decide which installer to use
./install/install-user-bashrc-path.sh
./install/install-user-manpage.sh

cd "$startDir"
