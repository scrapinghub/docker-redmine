#!/bin/sh

set -e

git_clone() {
    REPO="$1"
    VERSION_HASH="$2"
    DST_DIR="$3"

    if [ -z $DST_DIR ]; then
        DST_DIR="`echo $REPO | sed 's/.*\/\(.*\)$/\\1/'`"
    fi

    if [ -d $DST_DIR ]; then
        echo "Plugin/theme $DST_DIR already installed."
        return
    fi

    echo "Cloning repo $REPO on directory: $DST_DIR"

    bash -c "git clone $REPO $DST_DIR && cd $DST_DIR && git checkout -qf $VERSION_HASH"
}

cd assets/plugins

git_clone https://github.com/scrapinghub/redmine_didyoumean c264073809d1a74f3efe0ff6fd80114f413dc822
git_clone https://github.com/credativUK/redmine_image_clipboard_paste 1bb13068433706b603a7a7302c0182f78c3d34c3
git_clone https://github.com/arkhitech/redmine_mentions 2f3122a9c81a24f4a47e34b72625055e28aed903
git_clone https://github.com/sciyoshi/redmine-slack 6129dd0004f38e3263b15431e5b6c2786aff876f redmine_slack
git_clone https://github.com/redcloak/redmine_s3 a3c98ae3373f5e139b92ffebed082634cc9bfe82

if [ -n "$*" ]; then
    for d in $*; do
        echo "Installing $d ..."
        TMPFILE=`mktemp`
        curl -s $d > $TMPFILE && unzip -n $TMPFILE && rm $TMPFILE
    done
fi

cd ../../assets/themes

for i in \
    https://github.com/lqez/redmine-theme-basecamp-with-icon     \
    https://github.com/Froiden/fedmine                           \
    https://github.com/pixel-cookers/redmine-theme               \
    https://github.com/AlphaNodes/bavarian_dawn                  \
    https://github.com/makotokw/redmine-theme-gitmike            \
    https://github.com/astout/metro_redmine                      \
    https://github.com/rubo77/freifunk-red-andy
do 
  git_clone $i
done