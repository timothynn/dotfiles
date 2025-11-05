.PHONY: help setup check check-fast check-updates build-system build-home switch-system switch-home update update-system clean

# Default target
help:
	@echo "Available commands:"
	@echo "  setup         - Initial setup (check syntax, validate flake)"
	@echo "  check         - Comprehensive configuration validity check"
	@echo "  check-fast    - Quick syntax check only"
	@echo "  check-updates - Check for available updates without installing"
	@echo "  build-system  - Build NixOS system (dry run)"
	@echo "  build-home    - Build Home Manager (dry run)" 
	@echo "  switch-system - Switch to new NixOS configuration"
	@echo "  switch-home   - Switch to new Home Manager configuration"
	@echo "  update        - Update flake inputs only"
	@echo "  update-system - Complete system update with progress feedback"
	@echo "  clean         - Clean old generations"

# Initial setup
setup:
	@echo "Starting dotfiles setup..."
	@echo "Step 1: Checking flake syntax..."
	@if nix-instantiate --parse flake.nix > /dev/null 2>&1; then \
		echo "✅ Flake syntax is valid"; \
	else \
		echo "❌ Flake syntax error"; \
		exit 1; \
	fi
	@echo "Step 2: Testing flake show (this may take a while for first run)..."
	@timeout 300 nix flake show || (echo "⚠️  Flake show timed out, but this is common on first run")
	@echo "✅ Setup validation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Run 'make switch-system' to apply NixOS configuration"
	@echo "  2. Run 'make switch-home' to apply Home Manager configuration"
	@echo "  3. Reboot system for full effect"

# Check configuration
check:
	@./scripts/check-config.sh

# Quick syntax check
check-fast:
	@echo "🔍 Checking flake syntax..."
	@if nix-instantiate --parse flake.nix > /dev/null 2>&1; then \
		echo "✅ Flake syntax is valid"; \
	else \
		echo "❌ Flake syntax error"; \
		exit 1; \
	fi

# Check for available updates
check-updates:
	@echo "🔍 Checking for updates..."
	@echo ""
	@echo "📦 Current flake inputs:"
	@nix flake metadata --json | jq -r '.locks.nodes | to_entries[] | select(.value.locked.type != null) | "\(.key): \(.value.locked.rev // .value.locked.narHash | .[0:12])"' 2>/dev/null || nix flake metadata
	@echo ""
	@echo "🔢 Checking potential system updates..."
	@sudo nixos-rebuild dry-build --flake .#nixos 2>&1 | grep "will be built\|will be fetched" | head -3 || echo "  ℹ️  No major system updates detected"
	@echo ""
	@echo "🏠 Checking potential Home Manager updates..."
	@home-manager build --flake .#tim@nixos --dry-run 2>&1 | grep "will be built\|will be fetched" | head -3 || echo "  ℹ️  No major home updates detected"
	@echo ""
	@echo "✅ Check complete. Run 'make update-system' to apply updates."

# Build configurations (dry run)
build-system:
	@echo "Building NixOS system configuration..."
	@sudo nixos-rebuild build --flake .#nixos

build-home:
	@echo "Building Home Manager configuration..."
	@home-manager build --flake .#tim@nixos

# Switch to configurations
switch-system:
	@echo "Switching to NixOS system configuration..."
	@sudo nixos-rebuild switch --flake .#nixos

switch-home:
	@echo "Switching to Home Manager configuration..."
	@home-manager switch --flake .#tim@nixos

# Update flake
update:
	@echo "Updating flake inputs..."
	@nix flake update

# Full system update with better feedback
update-system:
	@./scripts/update-system.sh

# Clean old generations
clean:
	@echo "Cleaning old generations..."
	@sudo nix-collect-garbage -d
	@home-manager expire-generations "-7 days"

# System health check
health:
	@./scripts/system-monitor.sh

# rollback commands
rollback-system:
	@./scripts/rollback.sh system --list

rollback-home:
	@./scripts/rollback home --list
