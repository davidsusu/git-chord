
# TODO collect automatically
declare -A COMMANDS=(
    ["help"]=""
    ["version"]=""
    ["config"]="get set list"
    ["snapshot"]=""
    ["apply"]=""
    ["state"]=""
    ["show"]=""
    ["diff"]=""
    ["push"]=""
    ["pull"]=""
)

# TODO collect automatically
OPTIONS=(
    "--trackers-prefix"
    "--trackers-name"
    "--trackers-remotes-default"
    "--trackers-remotes-allowautoadd"
    "--branches-store-enabled"
    "--branches-store-regex"
    "--branches-apply-enabled"
    "--branches-apply-regex"
    "--branches-apply-allowremove"
    "--branches-apply-allowadd"
    "--annotatedtags-store-enabled"
    "--annotatedtags-store-regex"
    "--annotatedtags-apply-enabled"
    "--annotatedtags-apply-regex"
    "--annotatedtags-apply-allowremove"
    "--annotatedtags-apply-allowadd"
    "--lightweighttags-store-enabled"
    "--lightweighttags-store-regex"
    "--lightweighttags-apply-enabled"
    "--lightweighttags-apply-regex"
    "--lightweighttags-apply-allowremove"
    "--lightweighttags-apply-allowadd"
    "--head-store-enabled"
    "--head-apply-enabled"
    "--stagingarea-store-enabled"
    "--stagingarea-apply-enabled"
    "--stagingarea-apply-allowoverwrite"
    "--workingtree-store-enabled"
    "--workingtree-apply-enabled"
    "--workingtree-apply-allowoverwrite"
    "--dryrun"
    "--verbose"
    "--color"
    "--markdown"
    "--defaults"
    "--all"
)

_git_chord() {
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
        COMPREPLY=( $( compgen -W "$( printf '%s ' "${!COMMANDS[@]}" )" -- "$current" ) )
        commandFound='1'
    elif [[ ${#prevWords[@]} -eq 1 && -n "${COMMANDS[${prevWords[0]}]}" ]]; then
        COMPREPLY=( $( compgen -W "${COMMANDS[${prevWords[0]}]}" -- "$current" ) )
        commandFound='1'
    elif [[ "$current" == '-'* ]]; then
        COMPREPLY=( $( compgen -W "$( printf '%s ' "${OPTIONS[@]}" )" -- "$current" ) )
    fi
    
    if [[ ${#COMPREPLY[@]} -eq 1 && "$current" != '--'* ]]; then
        COMPREPLY[0]+=" "
    fi
}
