#!/bin/bash
# Integration tests: Content, feed, and navigation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="${1:-.}"
DIST_DIR="$PROJECT_ROOT/dist"

# ----- Test: Feed file is valid XML
if command -v xmllint &> /dev/null; then
    xmllint --noout "$DIST_DIR/feed.xml" 2>/dev/null
    test_result $? "feed.xml is valid XML"
else
    python3 -c "import xml.etree.ElementTree as ET; ET.parse('$DIST_DIR/feed.xml')" 2>/dev/null
    test_result $? "feed.xml is valid XML"
fi

# ----- Test: Feed has expected structure
grep -q '<rss' "$DIST_DIR/feed.xml"
test_result $? "feed.xml has <rss> element"

grep -q '<channel>' "$DIST_DIR/feed.xml"
test_result $? "feed.xml has <channel> element"

ITEM_COUNT=$(grep -c '<item>' "$DIST_DIR/feed.xml" || true)
[ "$ITEM_COUNT" -ge 1 ]
test_result $? "feed.xml has items ($ITEM_COUNT found)"

# ----- Test: Navigation links are present
grep -q 'href.*blog' "$DIST_DIR/index.html"
test_result $? "index.html has blog link"

grep -q 'href.*code' "$DIST_DIR/index.html"
test_result $? "index.html has code link"

grep -q 'href.*privacy' "$DIST_DIR/index.html"
test_result $? "index.html has privacy link"

# ----- Test: Blog index has blog posts
grep -q 'blog.*html' "$DIST_DIR/blog/index.html"
test_result $? "blog/index.html references blog posts"

# ----- Test: CSS and JS files are linked
grep -q 'app.css' "$DIST_DIR/index.html"
test_result $? "index.html links to CSS"

grep -q 'app.js' "$DIST_DIR/index.html"
test_result $? "index.html links to JavaScript"

# Print summary if run standalone
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo
    print_summary
    exit $?
fi
