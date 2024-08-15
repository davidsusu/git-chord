#!/bin/sh

selfDir="$( dirname -- "$( realpath "$0" )" )"
buildDir="${selfDir}/build"
projectRootDir="$( realpath "$selfDir"/../../.. )"

outDir="$1"
if [ -z "$outDir" ]; then
    echo 'FATAL: No output directory was specified' 1>&2
    exit 1
fi

if ! mkdir -p "$outDir"; then
    echo 'FATAL:' 1>&2
    exit 1
fi

mkdir -p "$buildDir"

# TODO
(
    cat "${projectRootDir}/README.md" | head -n 1;
    printf '\n\n...\n\n\n'
    cat "${projectRootDir}/README.md" | tail -n +3;
) | pandoc -s -f gfm -t man -o "${buildDir}/git-chord.1"
