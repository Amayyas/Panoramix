#!/usr/bin/env bash

# Acceptance tests for the Panoramix project.
# These tests validate the high-level contract of the subject.

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

echo "=== Panoramix Acceptance Tests ==="
echo

echo "Building project..."
make -C "$REPO_DIR" >/dev/null

echo "Checking subject-level contract..."

run_case NO_ARGS_OUTPUT NO_ARGS_STATUS "$BINARY"
assert_exit_code "Missing arguments rejected" 84 "$NO_ARGS_OUTPUT" "$NO_ARGS_STATUS"

run_case ZERO_OUTPUT ZERO_STATUS "$BINARY" 0 1 1 1
assert_exit_code "Zero values rejected" 84 "$ZERO_OUTPUT" "$ZERO_STATUS"

run_case NEGATIVE_OUTPUT NEGATIVE_STATUS "$BINARY" -1 2 2 1
assert_exit_code "Negative values rejected" 84 "$NEGATIVE_OUTPUT" "$NEGATIVE_STATUS"

echo
echo "Checking acceptable execution scenarios..."

run_case MINIMAL_OUTPUT MINIMAL_STATUS timeout 5 "$BINARY" 1 1 1 1
assert_exit_code "Minimal valid scenario terminates" 0 "$MINIMAL_OUTPUT" "$MINIMAL_STATUS"

run_case SMALL_OUTPUT SMALL_STATUS timeout 5 "$BINARY" 2 3 2 1
assert_exit_code "Small valid scenario terminates" 0 "$SMALL_OUTPUT" "$SMALL_STATUS"

echo
echo "=== Results ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -ne 0 ]; then
    exit 1
fi

exit 0