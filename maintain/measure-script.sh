#!/bin/sh

MIN_SKIP=30

startDirectory="$( realpath "$( dirname -- "$( realpath "$0" )" )" )"

interpreter="$( realpath "$1" )"
shift
contextDirectory="$( realpath "$1" )"
shift
scriptFile="$( realpath "$1" )"
shift

cd "$contextDirectory"

checkStartsWith() { # $1: contextString, $2: prefixToCheck
    case "$1" in
        "$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

checkEndWith() { # $1: contextString, $2: suffixToCheck
    case "$1" in
        *"$2") return 0 ;;
        *) return 1 ;;
    esac
}

checkContains() { # $1: contextString, $2: infixToCheck
    case "$1" in
        *"$2"*) return 0 ;;
        *) return 1 ;;
    esac
}

checkContains3() { # $1: contextString, $2: infixToCheck1, $3: infixToCheck2, $4: infixToCheck3
    case "$1" in
        *"$2"*|*"$3"*|*"$4"*) return 0 ;;
        *) return 1 ;;
    esac
}

measureFunctionDefinition='
_MEASURE() {
    _MEASURE_NEXT_TIMESTAMP="$( date "'"+%s%N"'" | cut -b1-16 )"
    if [ -n "$_MEASURE_PREVIOUS_TIMESTAMP" ]; then
        printf "'"%10s - %s\n"'" "$(( _MEASURE_NEXT_TIMESTAMP - _MEASURE_PREVIOUS_TIMESTAMP ))" "$1" >&2
    fi
    _MEASURE_PREVIOUS_TIMESTAMP="$_MEASURE_NEXT_TIMESTAMP"
}
'

if ! tmpFile="$( mktemp -p '/tmp' 'measure.XXXXXX' )"; then
    echo 'Failed to create temporary file'
    exit 1
fi

waitUntil=''
moveCounter='1'
counter=-1
lineNo=0
lastLineNo=-1
cat "$scriptFile" | sed -E "s/(^(.*\|\s*)?(if |case |for |while |do\b|\w+\(\)\s*(\{|\())[^#]*)( #[^\"']*|\s*;\s*)$/\1/" | while IFS='' read -r line; do
    lineNo=$(( lineNo + 1 ))
    if [ -n "$moveCounter" ]; then
        counter=$(( counter - 1 ))
    fi
    if checkContains "$line" 'exit' && printf '%s\n' "$line" | grep -qE '^\s*exit(\s+[0-9]+)?(\s*;)?\s*$'; then
        printf "_MEASURE 'EXIT Lines %s .. %s'\n" "$lastLineNo" "$lineNo"
    fi
    printf '%s\n' "$line"
    if checkStartsWith "$line" '#!'; then
        printf '%s\n' "$measureFunctionDefinition"
        printf "_MEASURE 'Initial at line %s'\n" "$lineNo"
        counter="$MIN_SKIP"
        lastLineNo="$lineNo"
    elif [ -n "$waitUntil" ]; then
        if checkStartsWith "$line" "$waitUntil" && { [ "$line" = "$waitUntil" ] || { [ "$waitUntil" = 'done' ] && checkStartsWith "$line" 'done <<' ; } ; }; then
            givenWaitUntil="$waitUntil"
            waitUntil=''
            moveCounter='1'
            if [ "$givenWaitUntil" = 'done' ]; then
                counter=-1
                if checkStartsWith "$line" 'done <<'; then
                    waitUntil="$( printf '%s\n' "$line" | sed -E 's/^done <<//' )"
                fi
            fi
        fi
    elif [ -z "$line" ]; then
        if [ "$counter" -lt 0 ]; then
            printf "_MEASURE 'Lines %s .. %s'\n" "$lastLineNo" "$lineNo"
            counter="$MIN_SKIP"
            lastLineNo="$lineNo"
        fi
    elif checkEndWith "$line" '() {'; then
        waitUntil='}'
        moveCounter=''
    elif checkEndWith "$line" '() ('; then
        waitUntil=')'
        moveCounter=''
    elif checkStartsWith "$line" 'if '; then
        waitUntil='fi'
    elif checkStartsWith "$line" 'case '; then
        waitUntil='esac'
    elif { checkContains3 "$line" 'while' 'for' 'do' ; } && printf '%s\n' "$line" | grep -qE '^((\S.*\|\s*)?(for|while)\b.*;\s*)?\bdo$' ; then
        waitUntil='done'
    fi
done > "$tmpFile"

"$interpreter" "$tmpFile" "$@" 2>&1 > /dev/null

rm "$tmpFile"

cd "$startDirectory"
