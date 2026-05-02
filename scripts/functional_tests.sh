#!/usr/bin/env bash

# Black-box functional tests for the Panoramix executable.
# These tests validate the observable behavior required by the subject.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BINARY="$REPO_DIR/panoramix"

PASS_COUNT=0
FAIL_COUNT=0

report_pass() {
    echo "[PASS] $1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

report_fail() {
    echo "[FAIL] $1"
    echo "       Expected pattern: $2"
    echo "       Output:"
    printf '%s\n' "$3" | sed 's/^/         /'
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

assert_output() {
    local test_name=$1
    local expected_pattern=$2
    local output=$3

    if printf '%s\n' "$output" | grep -Eq "$expected_pattern"; then
        report_pass "$test_name"
    else
        report_fail "$test_name" "$expected_pattern" "$output"
    fi
}

echo "=== Panoramix Functional Tests ==="
echo

echo "Building project..."
make -C "$REPO_DIR" >/dev/null

echo "Checking argument handling..."
NO_ARGS_OUTPUT=$("$BINARY" 2>&1 || true)
assert_output \
    "Usage message without arguments" \
    '^USAGE: ./panoramix <nb_villagers> <pot_size> <nb_fights> <nb_refills>$' \
    "$NO_ARGS_OUTPUT"

ZERO_VALUES_OUTPUT=$("$BINARY" 0 1 1 1 2>&1 || true)
assert_output \
    "Invalid zero values message" \
    'Values must be >0\.' \
    "$ZERO_VALUES_OUTPUT"

NEGATIVE_VALUES_OUTPUT=$("$BINARY" -1 3 2 1 2>&1 || true)
assert_output \
    "Negative values message" \
    'Values must be >0\.' \
    "$NEGATIVE_VALUES_OUTPUT"

echo
echo "Checking nominal execution flow..."
NOMINAL_OUTPUT=$(timeout 5 "$BINARY" 2 3 2 1 2>&1 || true)

assert_output \
    "Druid startup message" \
    "Druid: I'm ready... but sleepy..." \
    "$NOMINAL_OUTPUT"

assert_output \
    "Druid awake message" \
    "Druid: Ah! Yes, yes, I'm awake! Working on it!" \
    "$NOMINAL_OUTPUT"

assert_output \
    "Villager battle start" \
    'Villager [0-9]+: Going into battle!' \
    "$NOMINAL_OUTPUT"

assert_output \
    "Villager drink message" \
    'Villager [0-9]+: I need a drink\.\.\. I see [0-9]+ servings left\.' \
    "$NOMINAL_OUTPUT"

assert_output \
    "Villager fight message" \
    'Villager [0-9]+: Take that roman scum! Only [0-9]+ left\.' \
    "$NOMINAL_OUTPUT"

assert_output \
    "Villager sleep message" \
    "Villager [0-9]+: I'm going to sleep now\." \
    "$NOMINAL_OUTPUT"

assert_output \
    "Druid out of viscum message" \
    "Druid: I'm out of viscum. I'm going back to... zZz" \
    "$NOMINAL_OUTPUT"

echo
echo "=== Results ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -ne 0 ]; then
    exit 1
fi

exit 0