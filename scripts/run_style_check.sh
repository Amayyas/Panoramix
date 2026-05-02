#!/usr/bin/env bash

# Run Epitech coding-style check using the official Docker image
# Usage: ./scripts/run_style_check.sh

set -euo pipefail

IMAGE=ghcr.io/epitech/coding-style-checker:latest

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker is not installed or not available in PATH. Install Docker to run the style check."
  exit 2
fi

echo "Pulling coding style checker image..."
docker pull "$IMAGE"

# Run the check.sh script inside the container, mounting the repository
echo "Running style check (this may take a few seconds)..."
docker run --rm \
  -v "$PWD":"$PWD" \
  -w "$PWD" \
  "$IMAGE" check.sh "$PWD" "$PWD"

EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
  echo "\nStyle check passed."
else
  echo "\nStyle check failed. See output above for details." >&2
fi
exit $EXIT_CODE
