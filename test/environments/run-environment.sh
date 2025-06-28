#!/bin/sh

selfDir="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"

export PROJECT_DIR="$( realpath "${selfDir}/../.." )"
export TESTS_DIR="$( realpath "${PROJECT_DIR}/test/tests" )"
export ENVIRONMENT_NAME="$1"
export ENVIRONMENT_DIR="${selfDir}/environments/${ENVIRONMENT_NAME}"
export ENVIRONMENT_FILE="${ENVIRONMENT_DIR}/run.sh"

if ! [ -f "$ENVIRONMENT_FILE" ]; then
    echo "Environment not found: ${ENVIRONMENT_NAME}"
    exit 1
fi

. "$ENVIRONMENT_FILE"
