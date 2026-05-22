#!/bin/bash

NC='\033[0m'
TXT='\033[0;32m' # green, or 1;32m for light green
SYM='\u2192' # right arrow

printf "${TXT}${SYM} This will publish the site on statichost.eu. Are you sure? [y/N] ${NC}"
read -r answer
[[ "${answer,,}" == "y" ]] || exit 0

./shcli mpadge ./dist
