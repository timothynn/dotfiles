#!/usr/bin/env bash

# Script to rebuild NixOS system configuration
# Usage: ./rebuild-system.sh [--test]

set -euo pipefail

FLAKE_DIR="$HOME/.dotfiles"
HOST=$(hostname)

cd "$FLAKE_DIR"

echo "🔄 Rebuilding NixOS system configuration for host: $HOST"

if [[ "${1:-}" == "--test" ]]; then
    echo "🧪 Testing configuration (no switch)..."
    sudo nixos-rebuild test --flake ".#$HOST" --show-trace
else
    echo "🚀 Switching to new configuration..."
    sudo nixos-rebuild switch --flake ".#$HOST" --show-trace
fi

echo "✅ System rebuild completed!"