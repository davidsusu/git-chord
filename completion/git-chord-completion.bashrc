
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
    "--trackers-prefix="
    "--trackers-name="
    "--trackers-remotes-default="
    "--trackers-remotes-allowautoadd"
    "--no-trackers-remotes-allowautoadd"
    "--branches-store-enabled"
    "--no-branches-store-enabled"
    "--branches-store-regex="
    "--branches-apply-enabled"
    "--no-branches-apply-enabled"
    "--branches-apply-regex="
    "--branches-apply-allowremove"
    "--no-branches-apply-allowremove"
    "--branches-apply-allowadd"
    "--no-branches-apply-allowadd"
    "--annotatedtags-store-enabled"
    "--no-annotatedtags-store-enabled"
    "--annotatedtags-store-regex="
    "--annotatedtags-apply-enabled"
    "--no-annotatedtags-apply-enabled"
    "--annotatedtags-apply-regex="
    "--annotatedtags-apply-allowremove"
    "--no-annotatedtags-apply-allowremove"
    "--annotatedtags-apply-allowadd"
    "--no-annotatedtags-apply-allowadd"
    "--lightweighttags-store-enabled"
    "--no-lightweighttags-store-enabled"
    "--lightweighttags-store-regex="
    "--lightweighttags-apply-enabled"
    "--no-lightweighttags-apply-enabled"
    "--lightweighttags-apply-regex="
    "--lightweighttags-apply-allowremove"
    "--no-lightweighttags-apply-allowremove"
    "--lightweighttags-apply-allowadd"
    "--no-lightweighttags-apply-allowadd"
    "--head-store-enabled"
    "--no-head-store-enabled"
    "--head-apply-enabled"
    "--no-head-apply-enabled"
    "--stagingarea-store-enabled"
    "--no-stagingarea-store-enabled"
    "--stagingarea-apply-enabled"
    "--no-stagingarea-apply-enabled"
    "--stagingarea-apply-allowoverwrite"
    "--no-stagingarea-apply-allowoverwrite"
    "--workingtree-store-enabled"
    "--no-workingtree-store-enabled"
    "--workingtree-apply-enabled"
    "--no-workingtree-apply-enabled"
    "--workingtree-apply-allowoverwrite"
    "--no-workingtree-apply-allowoverwrite"
    "--dryrun"
    "--no-dryrun"
    "--verbose"
    "--no-verbose"
    "--color"
    "--no-color"
    "--markdown"
    "--no-markdown"
    "--defaults"
    "--no-defaults"
    "--all"
    "--no-all"
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
    
    if [[ ${#COMPREPLY[@]} -eq 1 && "${COMPREPLY[0]}" != '--'*'=' ]]; then
        COMPREPLY[0]+=" "
    fi
}
