#!/bin/sh

selfDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"

for environmentFile in "${selfDir}/environments/"*'/run.sh'; do
    environmentName="$( basename "$( dirname "$environmentFile" )" | sed -E 's/\.case\.sh$//' )"
    printf '=== Environment: %s ===\n' "$environmentName" 
    "${selfDir}/run-environment.sh" "$environmentName"
    printf '\n'
done
