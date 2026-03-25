#!/bin/bash
# Integration test suite - main orchestrator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RESULTS_FILE=$(mktemp)

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
        echo "PASS" >> "$RESULTS_FILE"
    else
        echo -e "${RED}✗${NC} $2"
        echo "FAIL" >> "$RESULTS_FILE"
    fi
}

# Export for subshells
export -f test_result
export RED GREEN NC RESULTS_FILE

echo "================================"
echo "Site Integration Tests"
echo "================================"
echo

# Build the site
echo "Building site..."
cd "$PROJECT_ROOT"
if yarn build > /dev/null 2>&1; then
    test_result 0 "Build completes successfully"
else
    test_result 1 "Build completes successfully"
fi
echo

# Run structure tests
echo "Testing structure..."
bash "$SCRIPT_DIR/integration-structure.sh" "$PROJECT_ROOT"
echo

# Run content tests
echo "Testing content..."
bash "$SCRIPT_DIR/integration-content.sh" "$PROJECT_ROOT"
echo

# Run HTML linting tests
echo "Linting HTML files..."
bash "$SCRIPT_DIR/integration-html-lints.sh" "$PROJECT_ROOT"
echo

# Count results
if [ -f "$RESULTS_FILE" ]; then
    TESTS_PASSED=$(grep "^PASS$" "$RESULTS_FILE" | wc -l)
    TESTS_FAILED=$(grep "^FAIL$" "$RESULTS_FILE" | wc -l)
else
    TESTS_PASSED=0
    TESTS_FAILED=0
fi
TOTAL=$((TESTS_PASSED + TESTS_FAILED))

# Cleanup
rm -f "$RESULTS_FILE"

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
