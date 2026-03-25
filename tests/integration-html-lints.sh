#!/bin/bash
# Integration tests: HTML linting and validation

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="${1:-.}"
DIST_DIR="$PROJECT_ROOT/dist"

# ----- Test: HTML files are valid
HTML_FILES=$(find "$DIST_DIR" -name "*.html" -type f)
HTML_COUNT=$(echo "$HTML_FILES" | wc -l)
test_result 0 "Found $HTML_COUNT HTML files"

# ----- Test: No empty HTML files
EMPTY_HTML=$(find "$DIST_DIR" -name "*.html" -type f -empty)
if [ -z "$EMPTY_HTML" ]; then
    test_result 0 "No empty HTML files"
else
    test_result 1 "Empty HTML files found: $EMPTY_HTML"
fi

# ----- Test: HTML files contain expected tags
grep -q "<html" "$DIST_DIR/index.html"
test_result $? "index.html has <html> tag"

grep -q "<head" "$DIST_DIR/index.html"
test_result $? "index.html has <head> tag"

grep -q "<body" "$DIST_DIR/index.html"
test_result $? "index.html has <body> tag"

# ----- Test: Critical closing tags
grep -q "</html>" "$DIST_DIR/index.html"
test_result $? "index.html has closing </html> tag"

grep -q "</head>" "$DIST_DIR/index.html"
test_result $? "index.html has closing </head> tag"

grep -q "</body>" "$DIST_DIR/index.html"
test_result $? "index.html has closing </body> tag"

# ----- Test: Accessibility attributes
grep -q 'lang=' "$DIST_DIR/index.html"
test_result $? "index.html has lang attribute"

# ----- Test: Meta tags
grep -q '<meta charset' "$DIST_DIR/index.html"
test_result $? "index.html has charset meta tag"

grep -q '<meta.*viewport' "$DIST_DIR/index.html"
test_result $? "index.html has viewport meta tag"

# ----- Test: Title tag
grep -q '<title>' "$DIST_DIR/index.html"
test_result $? "index.html has <title> tag"

grep -q '</title>' "$DIST_DIR/index.html"
test_result $? "index.html has closing </title> tag"

# ----- Test: No unresolved Handlebars templates
grep -q '{{' "$DIST_DIR/index.html"
RESULT=$?
if [ $RESULT -eq 0 ]; then
    test_result 1 "Unresolved Handlebars templates found in index.html"
else
    test_result 0 "No unresolved Handlebars templates in index.html"
fi

# ----- Test: No inline console errors
INLINE_ERRORS=$(grep -c "console\\.error" "$DIST_DIR/index.html" 2>/dev/null)
if [ -z "$INLINE_ERRORS" ]; then INLINE_ERRORS=0; fi
[ "$INLINE_ERRORS" -eq 0 ]
test_result $? "No inline console errors in index.html"

# ----- Test: No duplicate IDs
DUPLICATE_IDS=$(grep -o 'id="[^"]*"' "$DIST_DIR/index.html" 2>/dev/null | sort | uniq -d | wc -l)
if [ -z "$DUPLICATE_IDS" ]; then DUPLICATE_IDS=0; fi
[ "$DUPLICATE_IDS" -eq 0 ]
test_result $? "No duplicate HTML IDs in index.html"

# ----- Test: Proper section closing tags
grep -q "</section>" "$DIST_DIR/blog/blog001.html"
test_result $? "Blog posts have proper section closing tags"

# ----- Test: HTML structure validation with tidy
if command -v tidy &> /dev/null; then
    tidy -q "$DIST_DIR/index.html" > /dev/null 2>&1
    test_result $? "index.html passes HTML structure validation"

    # For blog posts, check all files for warnings but ignore utterances script attributes (intentional)
    BLOG_FILES=$(find "$DIST_DIR/blog" -name "blog*.html" -type f | sort)
    TOTAL_BLOG_WARNINGS=0
    for BLOG_FILE in $BLOG_FILES; do
        BLOG_WARNINGS=$(tidy -q "$BLOG_FILE" 2>&1 | head -20 | grep -i "warning" | grep -v "proprietary attribute" | wc -l)
        TOTAL_BLOG_WARNINGS=$((TOTAL_BLOG_WARNINGS + BLOG_WARNINGS))
    done

    if [ "$TOTAL_BLOG_WARNINGS" -eq 0 ]; then
        test_result 0 "All blog posts pass HTML structure validation"
    else
        test_result 1 "All blog posts pass HTML structure validation ($TOTAL_BLOG_WARNINGS warnings found)"
    fi
else
    test_result 2 "tidy not installed (skipped HTML structure validation)"
fi

# Print summary if run standalone
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo
    print_summary
    exit $?
fi
