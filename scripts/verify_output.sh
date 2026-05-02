#!/bin/bash

# Script to verify output formatting matches Subject PDF requirements
# Issue #9: Ensure Output Formatting Match

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0

# Function to test output pattern
test_pattern() {
    local test_name=$1
    local output=$2
    local pattern=$3
    
    if echo "$output" | grep -q "$pattern"; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((PASSED++))
    else
        echo -e "${RED}✗${NC} $test_name"
        echo "  Expected pattern: $pattern"
        echo "  Got output: '$output'"
        ((FAILED++))
    fi
}

echo "=== Output Formatting Verification (Issue #9) ==="
echo ""

# Build the program
if ! make > /dev/null 2>&1; then
    echo -e "${RED}Failed to build panoramix${NC}"
    exit 1
fi

echo "Testing output formats..."
echo ""

# Test 1: Usage message (no arguments)
OUTPUT=$(./panoramix 2>&1 || true)
test_pattern "USAGE message format" "$OUTPUT" "USAGE: ./panoramix <nb_villagers> <pot_size> <nb_fights> <nb_refills>"

# Test 1b: Values check message (invalid arguments)
OUTPUT=$(./panoramix 0 1 1 1 2>&1 || true)
test_pattern "Values check message" "$OUTPUT" "Values must be >0."

# Test 2: Invalid arguments
OUTPUT=$(./panoramix -1 3 2 1 2>&1 || true)
test_pattern "Negative argument handling" "$OUTPUT" "Values must be >0."

# Test 3: Run simple simulation and check output patterns
OUTPUT=$(timeout 5 ./panoramix 2 3 2 1 2>&1 || true)

# Druid messages
test_pattern "Druid startup message" "$OUTPUT" "Druid: I'm ready... but sleepy..."
test_pattern "Druid awake message" "$OUTPUT" "Druid: Ah! Yes, yes, I'm awake! Working on it!"
test_pattern "Druid refill count message" "$OUTPUT" "Beware I can only make [0-9]* more refills after this one"
test_pattern "Druid out of ingredients" "$OUTPUT" "Druid: I'm out of viscum. I'm going back to... zZz"

# Villager messages
test_pattern "Villager battle start" "$OUTPUT" "Villager [0-9]*: Going into battle!"
test_pattern "Villager drink message" "$OUTPUT" "Villager [0-9]*: I need a drink... I see [0-9]* servings left."
test_pattern "Villager fight message" "$OUTPUT" "Villager [0-9]*: Take that roman scum! Only [0-9]* left."
test_pattern "Villager sleep message" "$OUTPUT" "Villager [0-9]*: I'm going to sleep now."

echo ""
echo "=== Results ==="
echo -e "${GREEN}Passed: $PASSED${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "${RED}Failed: $FAILED${NC}"
    exit 1
else
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
fi
