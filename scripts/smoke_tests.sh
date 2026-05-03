#!/usr/bin/env bash

# Smoke tests for Panoramix.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BINARY="$REPO_DIR/panoramix"

PASS_COUNT=0
FAIL_COUNT=0

pass() {
    echo "[PASS] $1"
    PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
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
    local expected=$2
    local output=$3
    local actual=$4

    if [ "$actual" -eq "$expected" ]; then
        pass "$name"
    else
        fail "$name" "exit code $expected" "$output"
    fi
}

assert_contains() {
    local name=$1
    local pattern=$2
    local output=$3

    if printf '%s\n' "$output" | grep -Eq "$pattern"; then
        pass "$name"
    else
        fail "$name" "pattern $pattern" "$output"
    fi
}

echo "=== Panoramix Smoke Tests ==="
echo

echo "Building project..."
make -C "$REPO_DIR" >/dev/null

run_case SMOKE_OUTPUT SMOKE_STATUS timeout 5 "$BINARY" 1 1 1 1

assert_exit_code "Minimal scenario exits successfully" \
    0 "$SMOKE_OUTPUT" "$SMOKE_STATUS"
assert_contains "Druid starts" \
    "Druid: I'm ready... but sleepy..." "$SMOKE_OUTPUT"
assert_contains "Villager starts" \
    "Villager 0: Going into battle!" "$SMOKE_OUTPUT"
assert_contains "Minimal scenario terminates" \
    "Villager 0: I'm going to sleep now\\." "$SMOKE_OUTPUT"

echo
echo "=== Results ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -ne 0 ]; then
    exit 1
fi

exit 0