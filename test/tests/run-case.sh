#!/bin/sh

startDir="$( realpath . )"
selfDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"

export TEST_NAME="$1"
export TEST_TMP_DIR="${TMPDIR:-/tmp}/mytmp."$$
export TEST_FILE="${selfDir}/cases/${TEST_NAME}.case.sh"

if ! [ -f "$TEST_FILE" ]; then
    echo "Test not found: ${TEST_NAME}"
    exit 1
fi

mkdir -p "$TEST_TMP_DIR"

testCaseCleanup() {
    rm -rf "$TEST_TMP_DIR"
}
trap testCaseCleanup EXIT INT TERM HUP

. ./lib/lib.sh

. "$TEST_FILE"
