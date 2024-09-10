#!/bin/sh

selfDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"
casesDir="${selfDir}/cases"
executable="/bin/sh"
if [ -n "$1" ]; then
    executable="$1"
fi

allOk='1'
while IFS= read -r file; do
    caseName="$( basename "$file" | sed -E 's/\..*$//' )"
    if ! printedMessage="$( "$executable" "$file" )"; then
        allOk=''
        printf '\e[1;31m%s\e[0m\n' "Test case '${caseName}' failed: ${printedMessage}"
    fi
done <<EOF
$( find "$casesDir"  -maxdepth 1 -type f )
EOF

if [ -n "$allOk" ]; then
    printf '\e[1;32m%s\e[0m\n' "All test cases succeed"
    exit 0
else
    exit 1
fi
