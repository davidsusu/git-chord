#!/bin/sh

selfDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"

executable="/bin/sh"
if [ -n "$1" ]; then
    executable="$1"
fi

allOk='1'
for testFile in "${selfDir}/cases/"*'.case.sh'; do
    testName="$( basename "$testFile" | sed -E 's/\.case\.sh$//' )"
    if ! printedMessage="$( "$executable" "${selfDir}/run-case.sh" "$testName" )"; then
        allOk=''
        printf '\e[1;31m%s\e[0m\n' "Test case '${testName}' failed: ${printedMessage}"
    fi
done

if [ -n "$allOk" ]; then
    printf '\e[1;32m%s\e[0m\n' "All test cases succeed"
    exit 0
else
    exit 1
fi
