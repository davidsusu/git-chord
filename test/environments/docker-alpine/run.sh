#!/bin/sh

selfDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"
rm -rf "${selfDir}/tmp"
mkdir -p "${selfDir}/tmp/bin"
mkdir -p "${selfDir}/tmp/home"
cp -R "${selfDir}/../../../bin/git-chord" "${selfDir}/tmp/bin/git-chord"
cp -R "${selfDir}/../../cases" "${selfDir}/tmp/home/cases"
cp -R "${selfDir}/../../run-cases.sh" "${selfDir}/tmp/home/run-cases.sh"
docker build -q . | xargs -I {} docker run --rm {}
rm -rf "${selfDir}/tmp"
