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

git_clone https://github.com/scrapinghub/redmine_didyoumean dc3bf214c3f5457955c668d8f8987b831441da2a
git_clone https://github.com/scrapinghub/redmine_mentions 90a5d0e6125335fe81403d74809b4aff0652e9eb
git_clone https://github.com/scrapinghub/redmine_emojibutton 0c224bc1dac9b6c1b07e9146dd4adfe23f3583fe

git_clone https://github.com/sciyoshi/redmine-slack 1c8524b58033ce35be1dcf091e22c0f5e84b9341 redmine_slack
git_clone https://github.com/redcloak/redmine_s3 34b8d3da8381ebba1765ed377520290c402f1095
git_clone https://github.com/a-ono/redmine_per_project_formatting 1c9f9efa2625af124160ce29caf1ba340869dd44
git_clone https://github.com/koppen/redmine_github_hook 094602fac8fb3dc7a56f0d3a1993345297c97204

# Disabled for now, because is not compatible with redmine 3
# git_clone https://github.com/credativUK/redmine_image_clipboard_paste 1bb13068433706b603a7a7302c0182f78c3d34c3

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
