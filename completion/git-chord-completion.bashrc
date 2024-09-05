
declare -A COMPL_GIT_CHORD_COMMANDS=()
COMPL_GIT_CHORD_OPTIONS=()

__git_chord_reload_autocomplete() {
    while IFS=' ' read -r command subCommands; do
        COMPL_GIT_CHORD_COMMANDS["$command"]="$subCommands"
    done <<EOF
$( git chord spec commands )
EOF
    while IFS=' ' read -r optionArg; do
        COMPL_GIT_CHORD_OPTIONS+=( "$optionArg" )
    done <<EOF
$( git chord spec options )
EOF
}

_git_chord() {
    if [[ ${#COMPL_GIT_CHORD_COMMANDS[@]} -eq 0 ]]; then
        __git_chord_reload_autocomplete
    fi
    
    local current=${COMP_WORDS[COMP_CWORD]}
    local wordCount=$((COMP_CWORD))

    local prevWords
    if [[ "${COMP_WORDS[0]}" == "git" && "${COMP_WORDS[1]}" == "chord" ]]; then
        prevWords=( "${COMP_WORDS[@]:2:$wordCount-2}" )
    else
        prevWords=( "${COMP_WORDS[@]:1:$wordCount-1}" )
    fi

    COMPREPLY=()
    local commandFound=''
    
    if [[ ${#prevWords[@]} -eq 0 ]]; then
        COMPREPLY=( $( compgen -W "$( printf '%s ' "${!COMPL_GIT_CHORD_COMMANDS[@]}" )" -- "$current" ) )
        commandFound='1'
    elif [[ ${#prevWords[@]} -eq 1 && -n "${COMPL_GIT_CHORD_COMMANDS[${prevWords[0]}]}" ]]; then
        COMPREPLY=( $( compgen -W "${COMPL_GIT_CHORD_COMMANDS[${prevWords[0]}]}" -- "$current" ) )
        commandFound='1'
    elif [[ "$current" == '-'* ]]; then
        COMPREPLY=( $( compgen -W "$( printf '%s ' "${COMPL_GIT_CHORD_OPTIONS[@]}" )" -- "$current" ) )
    fi
    
    if [[ ${#COMPREPLY[@]} -eq 1 && "${COMPREPLY[0]}" != '--'*'=' ]]; then
        COMPREPLY[0]+=" "
    fi
}
