#!/bin/sh

selfDir="$( dirname -- "$( realpath "$0" )" )"

while IFS= read -r buildFile; do
    "$buildFile" "${selfDir}/out"
done <<EOF
$( printf '%s\n' "${selfDir}/builders/"*"/build.sh" )
EOF
