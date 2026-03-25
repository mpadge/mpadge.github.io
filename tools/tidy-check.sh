#!/bin/bash

# Check HTML files with tidy and show warnings with context
# Called from `make tidycheck`

tidy_check_file() {
	local file="$1"
	echo "Checking $file:"
	tidy "$file" 2>&1 | grep "Warning:" | grep -v "proprietary attribute" | head -5 | while read line; do
		linenum=$(echo "$line" | cut -d" " -f2)
		echo "  $line"
		sed -n "$((linenum-1)),$((linenum+1))p" "$file" | sed "s/^/    /"
		echo
	done
}

for file in $(find dist -name "*.html" -type f | sort); do
	tidy "$file" 2>&1 | grep -q "Warning:" && tidy_check_file "$file"
done
