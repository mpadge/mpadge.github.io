#!/bin/bash

echo -e "\033[0;32mDeploying new blog...\033[0m"

if ! git st | egrep "On branch source"
then
    git checkout source
fi

foundation build
git checkout master

echo -e "\033[0;32mDeleting old site...\033[0m"
rm -r assets/ blog/

echo -e "\033[0;32mTransferring new contents...\033[0m"
mkdir assets
mkdir blog
mv dist/index.html .
mv dist/blog.html .
mv dist/blog/*.html blog/.
mv dist/assets/* assets/.
rm -r dist

# first line of index.html is blank, which mucks up github pages, so must be
# removed:
sed -i '1d' index.html

echo -e "\033[0;32mUpdating git...\033[0m"
git add index.html blog.html blog/* assets/*
git commit -am "New Blog Build (`date`)"
git push

echo -e "\033[0;32mChange back to source branch...\033[0m"
git checkout source

echo -e "\033[0;32mDeploy complete.\033[0m"
