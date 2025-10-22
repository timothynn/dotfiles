#!/usr/bin/env bash

# Script to update flake inputs
# Usage: ./update-flake.sh [input_name]

set -euo pipefail

FLAKE_DIR="$HOME/.dotfiles"

cd "$FLAKE_DIR"

if [[ $# -eq 0 ]]; then
    echo "🔄 Updating all flake inputs..."
    nix flake update --show-trace
else
    echo "🔄 Updating flake input: $1"
    nix flake lock --update-input "$1" --show-trace
fi

echo "✅ Flake update completed!"
echo "💡 Don't forget to rebuild your system and home configurations."