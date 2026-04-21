#!/bin/bash
# Integration tests: src/data generation and Rmd YAML front-matter parsing

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

PROJECT_ROOT="${1:-.}"
BLOG_SRC="$PROJECT_ROOT/src/pages/blog"
DATA_DIR="$PROJECT_ROOT/src/data"
DIST_BLOG="$PROJECT_ROOT/dist/blog"

# -------------------------------------------------------------------------
# Rmd YAML front-matter: structural validity
# -------------------------------------------------------------------------

RMD_FILES=$(find "$BLOG_SRC" -name "*.Rmd" | sort)
RMD_COUNT=$(echo "$RMD_FILES" | wc -l)
[ "$RMD_COUNT" -ge 1 ]
test_result $? "Found $RMD_COUNT Rmd blog files"

# Every Rmd has a YAML block (at least two --- delimiters)
MISSING_YAML=0
for f in $RMD_FILES; do
    count=$(grep -c '^---$' "$f" 2>/dev/null || echo 0)
    [ "$count" -ge 2 ] || MISSING_YAML=$((MISSING_YAML + 1))
done
[ "$MISSING_YAML" -eq 0 ]
test_result $? "All Rmd files have YAML front-matter delimiters"

# Every Rmd has title:, date:, and link: fields in its YAML block
MISSING_FIELDS=0
for f in $RMD_FILES; do
    block=$(awk '/^---$/{n++; if(n==2) exit} n==1' "$f")
    echo "$block" | grep -q '^title:'       || MISSING_FIELDS=$((MISSING_FIELDS + 1))
    echo "$block" | grep -q '^date:'        || MISSING_FIELDS=$((MISSING_FIELDS + 1))
    echo "$block" | grep -q '^link:'        || MISSING_FIELDS=$((MISSING_FIELDS + 1))
done
[ "$MISSING_FIELDS" -eq 0 ]
test_result $? "All Rmd files have title, date, and link fields"

# Date fields are parseable (DD/MM/YYYY or D/DD Month/Mon YYYY formats)
INVALID_DATES=0
for f in $RMD_FILES; do
    block=$(awk '/^---$/{n++; if(n==2) exit} n==1' "$f")
    date_val=$(echo "$block" | grep '^date:' | sed 's/^date: *//')
    echo "$date_val" | grep -qE '^[0-9]{1,2}/[0-9]{2}/[0-9]{4}$|^[0-9]{1,2} [A-Za-z]+ [0-9]{4}$' \
        || INVALID_DATES=$((INVALID_DATES + 1))
done
[ "$INVALID_DATES" -eq 0 ]
test_result $? "All Rmd date fields match expected formats"

# link: fields end in .html and use new slug names (no old blog0xx pattern)
BAD_LINKS=0
for f in $RMD_FILES; do
    block=$(awk '/^---$/{n++; if(n==2) exit} n==1' "$f")
    link_val=$(echo "$block" | grep '^link:' | sed 's/^link: *//')
    echo "$link_val" | grep -q '\.html$'          || BAD_LINKS=$((BAD_LINKS + 1))
    echo "$link_val" | grep -qE '^blog[0-9]+\.html' && BAD_LINKS=$((BAD_LINKS + 1))
done
[ "$BAD_LINKS" -eq 0 ]
test_result $? "All Rmd link fields use slug names (no old blog0xx.html)"

# Filenames follow YYYY-MM-DD-slug pattern
BAD_NAMES=0
for f in $RMD_FILES; do
    basename "$f" | grep -qE '^[0-9]{4}-[0-9]{2}-[0-9]{2}-.+\.Rmd$' \
        || BAD_NAMES=$((BAD_NAMES + 1))
done
[ "$BAD_NAMES" -eq 0 ]
test_result $? "All Rmd filenames follow YYYY-MM-DD-slug.Rmd pattern"

# -------------------------------------------------------------------------
# blog.yml: structure and content
# -------------------------------------------------------------------------

[ -f "$DATA_DIR/blog.yml" ]
test_result $? "src/data/blog.yml exists"

ENTRY_COUNT=$(grep -c '^-$' "$DATA_DIR/blog.yml" 2>/dev/null || echo 0)
[ "$ENTRY_COUNT" -eq "$RMD_COUNT" ]
test_result $? "blog.yml has $ENTRY_COUNT entries (matches $RMD_COUNT Rmd files)"

# Every entry has title, description, created, link — count each field; each must equal entry count
TITLE_COUNT=$(grep -c '^ *title:'       "$DATA_DIR/blog.yml" || echo 0)
DESCR_COUNT=$(grep -c '^ *description:' "$DATA_DIR/blog.yml" || echo 0)
CREA_COUNT=$(grep -c '^ *created:'      "$DATA_DIR/blog.yml" || echo 0)
LINK_COUNT=$(grep -c '^ *link:'         "$DATA_DIR/blog.yml" || echo 0)
[ "$TITLE_COUNT" -eq "$ENTRY_COUNT" ] && \
[ "$DESCR_COUNT" -eq "$ENTRY_COUNT" ] && \
[ "$CREA_COUNT"  -eq "$ENTRY_COUNT" ] && \
[ "$LINK_COUNT"  -eq "$ENTRY_COUNT" ]
test_result $? "All blog.yml entries have required fields (title, description, created, link)"

# No entry uses old-style blog0xx.html links
grep -qE 'link: blog[0-9]+\.html' "$DATA_DIR/blog.yml"
OLD_LINKS=$?
[ "$OLD_LINKS" -ne 0 ]
test_result $? "blog.yml contains no old-style blog0xx.html links"

# Every link in blog.yml corresponds to a built HTML file
MISSING_HTML=0
while IFS= read -r link_val; do
    [ -f "$DIST_BLOG/$link_val" ] || MISSING_HTML=$((MISSING_HTML + 1))
done < <(grep '^ *link:' "$DATA_DIR/blog.yml" | sed 's/.*link: *//')
[ "$MISSING_HTML" -eq 0 ]
test_result $? "All blog.yml links resolve to built HTML files"

# -------------------------------------------------------------------------
# blogshort.yml: structure
# -------------------------------------------------------------------------

[ -f "$DATA_DIR/blogshort.yml" ]
test_result $? "src/data/blogshort.yml exists"

SHORT_COUNT=$(grep -c '^-$' "$DATA_DIR/blogshort.yml" 2>/dev/null || echo 0)
[ "$SHORT_COUNT" -le 6 ]
test_result $? "blogshort.yml has at most 6 entries ($SHORT_COUNT found)"

grep -q 'link: blog/' "$DATA_DIR/blogshort.yml"
test_result $? "blogshort.yml links carry blog/ prefix"

# -------------------------------------------------------------------------
# updated: field propagation
# -------------------------------------------------------------------------

# Collect Rmd files that have an updated: field
UPDATED_RMDS=$(grep -rl '^updated:' "$BLOG_SRC" --include='*.Rmd' | sort)
UPDATED_COUNT=$(echo "$UPDATED_RMDS" | grep -c '.' 2>/dev/null || echo 0)

if [ "$UPDATED_COUNT" -gt 0 ]; then
    # Each such Rmd has its updated: value in blog.yml
    MISSING_UPD=0
    for f in $UPDATED_RMDS; do
        block=$(awk '/^---$/{n++; if(n==2) exit} n==1' "$f")
        link_val=$(echo "$block" | grep '^link:' | sed 's/^link: *//')
        # Find the blog.yml block for this link and check for updated:
        awk -v link="$link_val" '
            /^-$/ { block=""; in_entry=1 }
            in_entry { block=block"\n"$0 }
            /link: / && $0 ~ link { found=block }
            END { print found }
        ' "$DATA_DIR/blog.yml" | grep -q 'updated:' || MISSING_UPD=$((MISSING_UPD + 1))
    done
    [ "$MISSING_UPD" -eq 0 ]
    test_result $? "Rmd files with updated: field have it propagated to blog.yml"

    # Built HTML for each updated Rmd contains the blog-updated span with arrow
    MISSING_SPAN=0
    for f in $UPDATED_RMDS; do
        block=$(awk '/^---$/{n++; if(n==2) exit} n==1' "$f")
        link_val=$(echo "$block" | grep '^link:' | sed 's/^link: *//')
        html_file="$DIST_BLOG/$link_val"
        [ -f "$html_file" ] || { MISSING_SPAN=$((MISSING_SPAN + 1)); continue; }
        grep -q 'blog-updated' "$html_file" || MISSING_SPAN=$((MISSING_SPAN + 1))
    done
    [ "$MISSING_SPAN" -eq 0 ]
    test_result $? "Updated posts render blog-updated span in built HTML"

    # The arrow character (&#x27F6; or ⟶) is present in those HTML files
    MISSING_ARROW=0
    for f in $UPDATED_RMDS; do
        block=$(awk '/^---$/{n++; if(n==2) exit} n==1' "$f")
        link_val=$(echo "$block" | grep '^link:' | sed 's/^link: *//')
        html_file="$DIST_BLOG/$link_val"
        [ -f "$html_file" ] || { MISSING_ARROW=$((MISSING_ARROW + 1)); continue; }
        grep -qE '&#x27F6;|⟶' "$html_file" || MISSING_ARROW=$((MISSING_ARROW + 1))
    done
    [ "$MISSING_ARROW" -eq 0 ]
    test_result $? "Updated posts contain long-arrow character in built HTML"
else
    test_result 0 "No Rmd files with updated: field (skipped propagation checks)"
fi

# Rmd files without updated: produce no blog-updated span in their HTML
NO_UPD_RMDS=$(grep -rL '^updated:' "$BLOG_SRC" --include='*.Rmd' | sort)
SPURIOUS_SPAN=0
for f in $NO_UPD_RMDS; do
    block=$(awk '/^---$/{n++; if(n==2) exit} n==1' "$f")
    link_val=$(echo "$block" | grep '^link:' | sed 's/^link: *//')
    html_file="$DIST_BLOG/$link_val"
    [ -f "$html_file" ] || continue
    grep -q 'blog-updated' "$html_file" && SPURIOUS_SPAN=$((SPURIOUS_SPAN + 1))
done
[ "$SPURIOUS_SPAN" -eq 0 ]
test_result $? "Posts without updated: field have no blog-updated span in HTML"

# Print summary if run standalone
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    echo
    print_summary
    exit $?
fi
