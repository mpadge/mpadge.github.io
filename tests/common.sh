#!/bin/bash
# Common functions for integration tests

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

TESTS_PASSED=0
TESTS_FAILED=0

test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC} $2"
        ((TESTS_FAILED++))
    fi
}

print_summary() {
    local total=$((TESTS_PASSED + TESTS_FAILED))
    echo "================================"
    echo "Test Results"
    echo "================================"
    echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}/$total"
    if [ $TESTS_FAILED -gt 0 ]; then
        echo -e "Failed: ${RED}$TESTS_FAILED${NC}/$total"
        return 1
    else
        echo -e "Failed: ${GREEN}0${NC}/$total"
        echo -e "${GREEN}All tests passed!${NC}"
        return 0
    fi
}

export -f test_result print_summary
export RED GREEN NC TESTS_PASSED TESTS_FAILED
