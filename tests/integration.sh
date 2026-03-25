#!/bin/bash
# Integration test suite - main orchestrator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "================================"
echo "Site Integration Tests"
echo "================================"
echo

# Build the site
echo "Building site..."
cd "$PROJECT_ROOT"
if yarn build > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Build completes successfully"
else
    echo -e "${RED}✗${NC} Build completes successfully"
fi
echo

# Run structure tests
echo "Testing structure..."
bash "$SCRIPT_DIR/integration-structure.sh" "$PROJECT_ROOT" 2>&1 | grep -v "^================================" | grep -v "^Test Results" | grep -v "^Passed:" | grep -v "^Failed:" | grep -v "^All tests"
echo

# Run content tests
echo "Testing content..."
bash "$SCRIPT_DIR/integration-content.sh" "$PROJECT_ROOT" 2>&1 | grep -v "^================================" | grep -v "^Test Results" | grep -v "^Passed:" | grep -v "^Failed:" | grep -v "^All tests"
echo

# Run HTML linting tests
echo "Linting HTML files..."
bash "$SCRIPT_DIR/integration-html-lints.sh" "$PROJECT_ROOT" 2>&1 | grep -v "^================================" | grep -v "^Test Results" | grep -v "^Passed:" | grep -v "^Failed:" | grep -v "^All tests"
echo

# Run all tests again to get final count
TEMP_OUTPUT=$(mktemp)
bash "$SCRIPT_DIR/integration-structure.sh" "$PROJECT_ROOT" 2>&1 | grep "✓\|✗" > "$TEMP_OUTPUT"
bash "$SCRIPT_DIR/integration-content.sh" "$PROJECT_ROOT" 2>&1 | grep "✓\|✗" >> "$TEMP_OUTPUT"
bash "$SCRIPT_DIR/integration-html-lints.sh" "$PROJECT_ROOT" 2>&1 | grep "✓\|✗" >> "$TEMP_OUTPUT"

TESTS_PASSED=$(grep "✓" "$TEMP_OUTPUT" 2>/dev/null | wc -l)
TESTS_FAILED=$(grep "✗" "$TEMP_OUTPUT" 2>/dev/null | wc -l)
TOTAL=$((TESTS_PASSED + TESTS_FAILED))

rm -f "$TEMP_OUTPUT"

# Summary
echo "================================"
echo "Test Results"
echo "================================"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}/$TOTAL"
if [ $TESTS_FAILED -gt 0 ]; then
    echo -e "Failed: ${RED}$TESTS_FAILED${NC}/$TOTAL"
    exit 1
else
    echo -e "Failed: ${GREEN}0${NC}/$TOTAL"
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
