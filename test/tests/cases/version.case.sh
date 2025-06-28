#!/bin/sh

expectedVersion='0.1.0-SNAPSHOT'
version="$( git chord version )"
if [ "$version" != "$expectedVersion" ]; then
    printf '%s\n' "Mismatching version: '$version' != '$expectedVersion'"
    exit 1
fi

exit 0
