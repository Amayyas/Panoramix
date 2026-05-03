#!/usr/bin/env bash

# Concurrency and stress tests for Panoramix.

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

assert_count() {
    local name=$1
    local pattern=$2
    local expected=$3
    local output=$4
    local actual

    actual=$(printf '%s\n' "$output" | grep -Ec "$pattern" || true)
    if [ "$actual" -eq "$expected" ]; then
        pass "$name"
    else
        fail "$name" "count $expected for $pattern" "$output"
    fi
}

assert_not_contains() {
    local name=$1
    local pattern=$2
    local output=$3

    if printf '%s\n' "$output" | grep -Eiq "$pattern"; then
        fail "$name" "no match for $pattern" "$output"
    else
        pass "$name"
    fi
}

run_stress_case() {
    local label=$1
    local villagers=$2
    local pot=$3
    local fights=$4
    local refills=$5
    local output status

    run_case output status timeout 10 "$BINARY" \
        "$villagers" "$pot" "$fights" "$refills"

    assert_exit_code "$label exits" 0 "$output" "$status"
    assert_count "$label all villagers terminate" \
        "Villager [0-9]+: I'm going to sleep now\\." \
        "$villagers" "$output"
    assert_not_contains "$label no crash traces" \
        "segmentation fault|core dumped|aborted" "$output"
}

echo "=== Panoramix Stress Tests ==="
echo

echo "Building project..."
make -C "$REPO_DIR" >/dev/null

run_stress_case "Stress case A" 6 3 2 4
run_stress_case "Stress case B" 8 3 2 5
run_stress_case "Stress case C" 10 4 2 6

echo
echo "=== Results ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -ne 0 ]; then
    exit 1
fi

exit 0