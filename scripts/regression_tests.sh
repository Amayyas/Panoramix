#!/usr/bin/env bash

# Regression tests for Panoramix.

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
    echo "       Expected: $2"
    echo "       Output:"
    printf '%s\n' "$3" | sed 's/^/         /'
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

run_case() {
    local __output_var=$1
    local __status_var=$2
    shift 2

    local __tmp_output
    set +e
    __tmp_output=$(
        "$@" 2>&1
    )
    local __status=$?
    set -e

    printf -v "$__output_var" '%s' "$__tmp_output"
    printf -v "$__status_var" '%s' "$__status"
}

assert_exit_code() {
    local name=$1
    local expected_code=$2
    local output=$3
    local actual_code=$4

    if [ "$actual_code" -eq "$expected_code" ]; then
        report_pass "$name"
    else
        report_fail "$name" "exit code $expected_code" "$output"
    fi
}

assert_not_contains() {
    local name=$1
    local pattern=$2
    local output=$3

    if printf '%s\n' "$output" | grep -Eq "$pattern"; then
        report_fail "$name" "no match for $pattern" "$output"
    else
        report_pass "$name"
    fi
}

assert_count() {
    local name=$1
    local pattern=$2
    local expected_count=$3
    local output=$4
    local actual_count

    actual_count=$(printf '%s\n' "$output" | grep -Ec "$pattern" || true)
    if [ "$actual_count" -eq "$expected_count" ]; then
        report_pass "$name"
    else
        report_fail "$name" "count $expected_count for $pattern" "$output"
    fi
}

echo "=== Panoramix Regression Tests ==="
echo

echo "Building project..."
make -C "$REPO_DIR" >/dev/null

echo "Running regression scenarios..."
for i in 1 2 3 4 5; do
    run_case REGRESSION_OUTPUT REGRESSION_STATUS timeout 6 "$BINARY" 3 3 2 1
    assert_exit_code "Regression run $i exits successfully" \
        0 "$REGRESSION_OUTPUT" "$REGRESSION_STATUS"
    assert_not_contains "Regression run $i keeps no negative servings" \
        "I see -" "$REGRESSION_OUTPUT"
    assert_count "Regression run $i keeps villager completion count" \
        "Villager [0-9]+: I'm going to sleep now\\." 3 \
        "$REGRESSION_OUTPUT"
done

echo
echo "=== Results ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -ne 0 ]; then
    exit 1
fi

exit 0