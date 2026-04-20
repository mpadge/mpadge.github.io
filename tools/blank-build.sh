#!/bin/bash

# IMPORTANT: First call foundation new to make new site called "blank"!

cd ..
# follow instructions in "foundation.md" to create new site
# foundation new
# menu-driven stuff ...
# name new site "blank"

cp -r mpadge/src/assets/fonts blank/src/assets/.
cp -r mpadge/src/assets/foundation-icons blank/src/assets/.
cp -r mpadge/src/assets/img blank/src/assets/.
cp mpadge/src/assets/js/highlight.pack.js blank/src/assets/js/.
cp mpadge/src/assets/scss/_settings.scss blank/src/assets/scss/.
cp mpadge/src/assets/scss/app.scss blank/src/assets/scss/.

cp mpadge/src/data/* blank/src/data/.
cp mpadge/src/layouts/* blank/src/layouts/.
cp -r mpadge/src/pages blank/src/.
cp -r mpadge/src/partials blank/src/.

cp -r mpadge/.git blank/.
cp mpadge/makefile blank/.
cp mpadge/script.sh blank/.
cp mpadge/blank-build.sh blank/.
cp mpadge/.gitignore blank/.

rm -rf mpadge
mv blank mpadge

cd mpadge
