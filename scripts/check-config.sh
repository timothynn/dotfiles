#!/usr/bin/env bash

# Script to check configuration validity
set -euo pipefail

FLAKE_DIR="$HOME/.dotfiles"
cd "$FLAKE_DIR"

echo "🔍 Checking flake syntax..."
if nix-instantiate --parse flake.nix > /dev/null; then
    echo "✅ Flake syntax is valid"
else
    echo "❌ Flake syntax error"
    exit 1
fi

echo "🔍 Checking NixOS configuration..."
if nix build ".#nixosConfigurations.nixos.config.system.build.toplevel" --dry-run > /dev/null 2>&1; then
    echo "✅ NixOS configuration is valid"
else
    echo "❌ NixOS configuration has errors"
    exit 1
fi

echo "🔍 Checking Home Manager configuration..."
if nix build ".#homeConfigurations.\"tim@nixos\".activationPackage" --dry-run > /dev/null 2>&1; then
    echo "✅ Home Manager configuration is valid"
else
    echo "❌ Home Manager configuration has errors"
    exit 1
fi

echo "🎉 All configurations are valid!"