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

git_clone https://github.com/scrapinghub/redmine_didyoumean b3ddd9a56c10be5a6afcb75277d52adc8e586c2b
git_clone https://github.com/scrapinghub/redmine_mentions b32426484905b8746550c9fbc9dce23858906798
git_clone https://github.com/a-ono/redmine_ckeditor 908e2f25fe99fba5df49e4239cb7706a3f783c24

# We are using 'scrapinghub' branch on this repo, so ensure to
# get the hash from that branch.
git_clone https://github.com/scrapinghub/redmine_emojibutton ca0afb36a0e9602b528e8e68513b5b13430939ba

git_clone https://github.com/sciyoshi/redmine-slack 1c8524b58033ce35be1dcf091e22c0f5e84b9341 redmine_slack
git_clone https://github.com/redcloak/redmine_s3 34b8d3da8381ebba1765ed377520290c402f1095
git_clone https://github.com/a-ono/redmine_per_project_formatting 1c9f9efa2625af124160ce29caf1ba340869dd44
git_clone https://github.com/koppen/redmine_github_hook 094602fac8fb3dc7a56f0d3a1993345297c97204
git_clone https://github.com/scrapinghub/redmine_image_clipboard_paste a235295e32f85df8f6ce08848aa99494921af272

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
