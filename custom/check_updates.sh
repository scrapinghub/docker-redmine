#!/bin/sh

git_clone() {
    if [[ "$1" == "git_clone" ]]; then
        shift
    fi
    REPO=$1
    HASH=$2
    echo "Repo: $REPO, hash: $HASH"

    DST_DIR=`mktemp -d`
    git clone $REPO $DST_DIR
    cd $DST_DIR
    git log $HASH..
    cd ~-
    rm -rf $DST_DIR

    # skip repo naming
    if [[ "$3" != "git_clone" ]]; then
        shift
    fi
    if [[ $3 ]]; then
        shift
        shift
        git_clone $*
    fi
}

`grep "^git_clone " install-plugins.sh`
