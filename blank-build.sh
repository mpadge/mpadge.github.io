#!/bin/bash

cd ..
#foundation new
# menu-driven stuff ...
# name new site "blank"

cp -r mpadge.github.io/src/assets/fonts blank/src/assets/.
cp -r mpadge.github.io/src/assets/foundation-icons blank/src/assets/.
cp -r mpadge.github.io/src/assets/img blank/src/assets/.
cp mpadge.github.io/src/assets/js/highlight.pack.js blank/src/assets/js/.
cp mpadge.github.io/src/assets/scss/_settings.scss blank/src/assets/scss/.
cp mpadge.github.io/src/assets/scss/app.scss blank/src/assets/scss/.

cp mpadge.github.io/src/data/* blank/src/data/.
cp mpadge.github.io/src/layouts/* blank/src/layouts/.
cp -r mpadge.github.io/src/pages blank/src/.
cp -r mpadge.github.io/src/partials blank/src/.

cp -r mpadge.github.io/.git blank/.

rm -rf mpadge.github.io
mv blank mpadge.github.io

cd mpadge.github.io
