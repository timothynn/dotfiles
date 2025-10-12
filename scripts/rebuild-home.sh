#!/usr/bin/env bash

# Script to rebuild Home Manager configuration
# Usage: ./rebuild-home.sh [--test]

set -euo pipefail

FLAKE_DIR="$HOME/.dotfiles"
USER=$(whoami)
HOST=$(hostname)

cd "$FLAKE_DIR"

echo "🏠 Rebuilding Home Manager configuration for user: $USER@$HOST"

if [[ "${1:-}" == "--test" ]]; then
    echo "🧪 Testing configuration (no switch)..."
    home-manager build --flake ".#$USER@$HOST" --show-trace
else
    echo "🚀 Switching to new configuration..."
    home-manager switch --flake ".#$USER@$HOST" --show-trace
fi

echo "✅ Home Manager rebuild completed!"