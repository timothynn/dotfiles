#!/usr/bin/env bash

# System update script for NixOS with better feedback
# This script provides clearer feedback during system updates

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the correct directory
if [[ ! -f "flake.nix" ]]; then
    log_error "flake.nix not found. Please run this script from your dotfiles directory."
    exit 1
fi

log_info "Starting system update process..."

# Step 1: Update flake inputs
log_info "Step 1/4: Updating flake inputs..."
if nix flake update; then
    log_success "Flake inputs updated successfully"
else
    log_error "Failed to update flake inputs"
    exit 1
fi

# Step 2: Check configuration syntax
log_info "Step 2/4: Checking configuration syntax..."
if nix-instantiate --parse flake.nix > /dev/null 2>&1; then
    log_success "Configuration syntax is valid"
else
    log_error "Configuration syntax error found"
    exit 1
fi

# Step 3: Build NixOS system (dry run first)
log_info "Step 3/4: Building NixOS system configuration..."
if sudo nixos-rebuild build --flake .#nixos; then
    log_success "NixOS system built successfully"
else
    log_error "Failed to build NixOS system"
    exit 1
fi

# Step 4: Switch to new configuration
log_info "Step 4/4: Switching to new NixOS configuration..."
if sudo nixos-rebuild switch --flake .#nixos; then
    log_success "Successfully switched to new NixOS configuration"
else
    log_error "Failed to switch to new configuration"
    exit 1
fi

# Optional: Update Home Manager if available
if command -v home-manager > /dev/null; then
    log_info "Updating Home Manager configuration..."
    if home-manager switch --flake .#tim@nixos; then
        log_success "Home Manager updated successfully"
    else
        log_warning "Home Manager update failed, but system update was successful"
    fi
fi

log_success "System update completed! 🎉"
log_info "You may want to reboot to ensure all changes take effect."