
testLib_printRepositoryState() {
    gitDir="$( realpath "$1" )"
    printf 'a:%s\n' "$( git -C "$gitDir" symbolic-ref --short HEAD 2>/dev/null )"
    git -C "$gitDir" branch --format='b:%(refname:short):%(objectname)' --sort=refname | grep -v -E '^b:chord/'
    git -C "$gitDir" for-each-ref refs/tags |
        grep -E '\w+ commit\s+refs/tags/' |
        sed -E 's/^([^ ]+) commit\trefs\/tags\/([^ ]+)$/c:\2:\1/' |
        sort
    git -C "$gitDir" for-each-ref refs/tags |
        grep -E '\w+ tag\s+refs/tags/' |
        sed -E 's/^([^ ]+) tag\trefs\/tags\/([^ ]+)$/d:\2:\1/' |
        sort
}

testLib_initRepo() {
    gitDir="$( realpath "$1" )"
    mkdir -p "$gitDir" &&
        git -C "$gitDir" init --initial-branch=main -q &&
        git -C "$gitDir" config user.name 'Git Chord Test' &&
        git -C "$gitDir" config user.email 'git-chord@example.com'
    return $?
}

export TESTLIB_TIME_COUNTER=978307200
testLib_resetTime() {
    export TESTLIB_TIME_COUNTER=978307200
}

testLib_incrementTime() {
    export TESTLIB_TIME_COUNTER=$(( TESTLIB_TIME_COUNTER + 1 ))
}

testLib_gitTimed() {
    testLib_incrementTime
    GIT_AUTHOR_DATE="${TESTLIB_TIME_COUNTER} +0000" GIT_COMMITTER_DATE="${TESTLIB_TIME_COUNTER} +0000" git "$@"
    return $?
}

testLib_createSimpleRepo() {
    testLib_resetTime
    
    gitDir="$( realpath "$1" )"
    testLib_initRepo "$gitDir"
    
    echo "Content A" > "${gitDir}/a.txt"
    git -C "$gitDir" add --all
    testLib_gitTimed -C "$gitDir" commit -m 'Add a.txt' -q
    
    testLib_gitTimed -C "$gitDir" tag -a 'v1.0.0' -m 'Version 1.0.0'
    
    echo "Content B" > "${gitDir}/b.txt"
    git -C "$gitDir" add --all
    testLib_gitTimed -C "$gitDir" commit -m 'Add b.txt' -q
    
    echo "Content C" > "${gitDir}/c.txt"
    git -C "$gitDir" add --all
    testLib_gitTimed -C "$gitDir" commit -m 'Add c.txt' -q
    
    testLib_gitTimed -C "$gitDir" tag -a 'v2.0.0' -m 'Version 2.0.0'
    
    git -C "$gitDir" checkout -b feature/lorem -q
    git -C "$gitDir" reset HEAD^ -q
    
    echo "Content D" > "${gitDir}/d.txt"
    git -C "$gitDir" add --all
    testLib_gitTimed -C "$gitDir" commit -m 'Add d.txt' -q
    
    testLib_gitTimed -C "$gitDir" tag 'ipsum'
    
    git -C "$gitDir" checkout main -q
}

testLib_describeSimpleRepo() {
    printf '%s\n' \
        a:main \
        b:feature/lorem:f26d3272861ced48dfdc885a5a5e6292b54f151e \
        b:main:d8979c8e8c46b8cc07a0758bf1b79277058c22ee \
        c:ipsum:f26d3272861ced48dfdc885a5a5e6292b54f151e \
        d:v1.0.0:ee4b5ff4603cef04dfae27ca756a621ce2e133a4 \
        d:v2.0.0:2267ddbd36b161d3a8865d3538e26cac33d6d224 \
    ;
}

testLib_stateSimpleRepo() {
    printf '%s\n' \
"timestamp: '2001-01-01T00:00:01Z'
branches:
    'feature/lorem': 'f26d3272861ced48dfdc885a5a5e6292b54f151e'
    'main': 'd8979c8e8c46b8cc07a0758bf1b79277058c22ee'
annotatedTags:
    'v1.0.0':
        tagId: 'ee4b5ff4603cef04dfae27ca756a621ce2e133a4'
        commitId: '61d29caf35a0bea18e64188e3849895aa7537398'
        message: 'Version 1.0.0'
    'v2.0.0':
        tagId: '2267ddbd36b161d3a8865d3538e26cac33d6d224'
        commitId: 'd8979c8e8c46b8cc07a0758bf1b79277058c22ee'
        message: 'Version 2.0.0'
lightWeightTags:
    'ipsum': f26d3272861ced48dfdc885a5a5e6292b54f151e
head:
    pointingTo: 'main'
    ref: 'main'
    commitId: 'd8979c8e8c46b8cc07a0758bf1b79277058c22ee'
stagingArea:
    treeId: '8e631a3def5188ae6be3c59ec8c69e3d60aba089'
workingTree:
    treeId: '8e631a3def5188ae6be3c59ec8c69e3d60aba089'
" \
    ;
}
