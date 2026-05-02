#!/usr/bin/env bash

# Acceptance tests for the Panoramix project.
# These tests verify that the executable matches the subject-level expectations.

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
    echo "       Expected pattern: $2"
    echo "       Output:"
    printf '%s\n' "$3" | sed 's/^/         /'
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

check() {
    local name=$1
    local pattern=$2
    local output=$3

    if printf '%s\n' "$output" | grep -Eq "$pattern"; then
        pass "$name"
    else
        fail "$name" "$pattern" "$output"
    fi
}

echo "=== Panoramix Acceptance Tests ==="
echo

echo "Building project..."
make -C "$REPO_DIR" >/dev/null

echo "Checking mandatory subject rules..."
NO_ARGS_OUTPUT=$("$BINARY" 2>&1 || true)
check "Usage message on missing arguments" \
    '^USAGE: ./panoramix <nb_villagers> <pot_size> <nb_fights> <nb_refills>$' \
    "$NO_ARGS_OUTPUT"

ZERO_OUTPUT=$("$BINARY" 0 1 1 1 2>&1 || true)
check "Reject zero values" 'Values must be >0\.' "$ZERO_OUTPUT"

NEGATIVE_OUTPUT=$("$BINARY" -1 2 2 1 2>&1 || true)
check "Reject negative values" 'Values must be >0\.' "$NEGATIVE_OUTPUT"

echo
echo "Checking a nominal subject scenario..."
SCENARIO_OUTPUT=$(timeout 5 "$BINARY" 2 3 2 1 2>&1 || true)

check "Druid announces readiness" "Druid: I'm ready... but sleepy..." "$SCENARIO_OUTPUT"
check "Druid wakes up on refill" "Druid: Ah! Yes, yes, I'm awake! Working on it!" "$SCENARIO_OUTPUT"
check "Villager enters battle" 'Villager [0-9]+: Going into battle!' "$SCENARIO_OUTPUT"
check "Villager requests potion" 'Villager [0-9]+: I need a drink\.\.\. I see [0-9]+ servings left\.' "$SCENARIO_OUTPUT"
check "Villager attacks romans" 'Villager [0-9]+: Take that roman scum! Only [0-9]+ left\.' "$SCENARIO_OUTPUT"
check "Villager goes to sleep" "Villager [0-9]+: I'm going to sleep now\." "$SCENARIO_OUTPUT"
check "Druid ends without viscum" "Druid: I'm out of viscum. I'm going back to... zZz" "$SCENARIO_OUTPUT"

echo
echo "=== Results ==="
echo "Passed: $PASS_COUNT"
echo "Failed: $FAIL_COUNT"

if [ "$FAIL_COUNT" -ne 0 ]; then
    exit 1
fi

exit 0