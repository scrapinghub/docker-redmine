#!/bin/bash -e

git_clone() {
    REPO="$1"
    VERSION_HASH="$2"
    DST_DIR="$3"

    if [ -z $DST_DIR ]; then
        DST_DIR="`echo $REPO | sed 's/.*\/\(.*\)$/\\1/' | tr '-' '_'`"
    fi

    if [ -d $DST_DIR ]; then
        echo "Plugin/theme $DST_DIR already installed."
        return
    fi

    echo "Cloning repo $REPO on directory: $DST_DIR"

    bash -c "git clone $REPO $DST_DIR && cd $DST_DIR && git checkout -qf $VERSION_HASH"
}

download_or_clone() {
    if [[ "$1" =~ ".zip" ]]; then
        echo "Installing $d ..."
        TMPFILE=`mktemp`
        curl -s $d > $TMPFILE && unzip -n $TMPFILE && rm $TMPFILE
    else
        git_clone $@
    fi
}

cd assets/plugins

git_clone https://github.com/scrapinghub/redmine_didyoumean c264073809d1a74f3efe0ff6fd80114f413dc822
git_clone https://github.com/credativUK/redmine_image_clipboard_paste 1bb13068433706b603a7a7302c0182f78c3d34c3
git_clone https://github.com/scrapinghub/redmine_mentions 19abe29da4a3c0adee29721035880796c3346d88
git_clone https://github.com/sciyoshi/redmine-slack 6129dd0004f38e3263b15431e5b6c2786aff876f redmine_slack
git_clone https://github.com/redcloak/redmine_s3 a3c98ae3373f5e139b92ffebed082634cc9bfe82

git_clone https://github.com/scrapinghub/redmine_emojibutton 06ef4eef47eb8f2e45777d58293186382df89614

git_clone https://github.com/a-ono/redmine_per_project_formatting ced76f76ee59b17e951c35616d96e84552fd8028
git_clone https://github.com/koppen/redmine_github_hook a0f2d924dac4c0d68b68eda774f732c45133a646

if [ -n "$*" ]; then
    for d in $*; do
        if [[ ! "$d" =~ "theme" ]]; then
            download_or_clone `echo $d | tr '=' ' '`
        fi
    done
fi

cd ../../assets/themes

if [ -n "$*" ]; then
    for d in $*; do
        if [[ "$d" =~ "theme" ]]; then
            download_or_clone `echo $d | tr '=' ' '`
        fi
    done
fi

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
