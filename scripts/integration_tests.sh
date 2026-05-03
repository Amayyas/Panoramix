#!/usr/bin/env bash

# Integration tests for Panoramix.

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

assert_contains() {
    local name=$1
    local pattern=$2
    local output=$3

    if printf '%s\n' "$output" | grep -Eq "$pattern"; then
        report_pass "$name"
    else
        report_fail "$name" "pattern $pattern" "$output"
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

echo "=== Panoramix Integration Tests ==="
echo

echo "Building project..."
make -C "$REPO_DIR" >/dev/null

echo "Running integration scenario..."
run_case INTEGRATION_OUTPUT INTEGRATION_STATUS timeout 6 "$BINARY" 3 3 2 1

assert_exit_code "Integration scenario exits successfully" \
    0 "$INTEGRATION_OUTPUT" "$INTEGRATION_STATUS"
assert_contains "Druid thread initialized" \
    "Druid: I'm ready... but sleepy..." "$INTEGRATION_OUTPUT"
assert_contains "Villager threads started" \
    "Villager [0-9]+: Going into battle!" "$INTEGRATION_OUTPUT"
assert_contains "Villager-druid synchronization triggered" \
    "Hey Pano wake up! We need more potion." "$INTEGRATION_OUTPUT"
assert_contains "Druid refill path executed" \
    "Druid: Ah! Yes, yes, I'm awake! Working on it!" "$INTEGRATION_OUTPUT"
assert_count "All villagers terminate" \
    "Villager [0-9]+: I'm going to sleep now\\." 3 "$INTEGRATION_OUTPUT"

echo
echo "=== Results ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -ne 0 ]; then
    exit 1
fi

exit 0