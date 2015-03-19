#!/bin/sh

set -e

cd assets/plugins

git_clone() {
    REPO="$1"
    VERSION_HASH="$2"
    DST_DIR="$3"

    if [ -z $DST_DIR ]; then
        DST_DIR="`echo $REPO | sed 's/.*\/\(.*\)$/\\1/'`"
    fi

    if [ -d $DST_DIR ]; then
        echo "Plugin $DST_DIR already installed."
        return
    fi

    echo "Cloning repo $REPO on directory: $DST_DIR"

    bash -c "git clone $REPO $DST_DIR && cd $DST_DIR && git checkout -qf $VERSION_HASH"
}

git_clone https://github.com/scrapinghub/redmine_didyoumean c264073809d1a74f3efe0ff6fd80114f413dc822
git_clone https://github.com/credativUK/redmine_image_clipboard_paste 1bb13068433706b603a7a7302c0182f78c3d34c3
git_clone https://github.com/arkhitech/redmine_mentions 2f3122a9c81a24f4a47e34b72625055e28aed903
git_clone https://github.com/sciyoshi/redmine-slack 6129dd0004f38e3263b15431e5b6c2786aff876f redmine_slack
git_clone https://github.com/ka8725/redmine_s3 af4ef4faa2247e31a5b859ef99b2674f3f7e4846

if [ -n "$*" ]; then
    for d in $*; do
        echo "Installing $d ..."
        TMPFILE=`mktemp`
        curl -s $d > $TMPFILE && unzip -n $TMPFILE && rm $TMPFILE
    done
fi
