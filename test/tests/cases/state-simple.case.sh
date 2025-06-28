#!/bin/sh

gitDir="$TEST_TMP_DIR"
testLib_createSimpleRepo "$gitDir"

expectedState="$( testLib_stateSimpleRepo )"

testLib_resetTime
givenState="$( testLib_gitTimed -C "$gitDir" chord state --fullstore )"

if [ "$givenState" != "$expectedState" ]; then
    echo "Unexpected state output"
    exit 1
fi
