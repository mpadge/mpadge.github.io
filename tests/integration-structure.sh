#!/bin/bash
# Integration tests: Build structure and file generation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="${1:-.}"
DIST_DIR="$PROJECT_ROOT/dist"

# ----- Test: dist directory exists
[ -d "$DIST_DIR" ]
test_result $? "dist/ directory created"

# ----- Test: Expected top-level files exist
[ -f "$DIST_DIR/index.html" ]
test_result $? "index.html exists"

[ -f "$DIST_DIR/privacy.html" ]
test_result $? "privacy.html exists"

[ -f "$DIST_DIR/feed.xml" ]
test_result $? "feed.xml exists"

# ----- Test: Expected directories exist
[ -d "$DIST_DIR/assets" ]
test_result $? "assets/ directory exists"

[ -d "$DIST_DIR/blog" ]
test_result $? "blog/ directory exists"

[ -d "$DIST_DIR/code" ]
test_result $? "code/ directory exists"

# ----- Test: Assets are copied
[ -f "$DIST_DIR/assets/css/app.css" ]
test_result $? "CSS file generated"

[ -f "$DIST_DIR/assets/js/app.js" ]
test_result $? "JavaScript file generated"

[ -d "$DIST_DIR/assets/foundation-icons" ]
test_result $? "Foundation icons directory exists"

# ----- Test: Blog posts are generated
BLOG_COUNT=$(find "$DIST_DIR/blog" -name "blog*.html" | wc -l)
[ "$BLOG_COUNT" -ge 10 ]
test_result $? "Blog posts generated ($BLOG_COUNT found)"

# ----- Test: Index files exist
[ -f "$DIST_DIR/blog/index.html" ]
test_result $? "blog/index.html exists"

[ -f "$DIST_DIR/code/index.html" ]
test_result $? "code/index.html exists"

# Print summary if run standalone
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo
    print_summary
    exit $?
fi
