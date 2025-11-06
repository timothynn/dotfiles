#!/usr/bin/env bash
# Script to install the enhancement files to your dotfiles

set -euo pipefail

DOTFILES_DIR="${HOME}/.dotfiles"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Installing dotfiles enhancements...${NC}"
echo

# Create directories if they don't exist
echo -e "${BLUE}Creating directories...${NC}"
mkdir -p "${DOTFILES_DIR}/modules/nixos/system"
mkdir -p "${DOTFILES_DIR}/modules/home-manager/services"
mkdir -p "${DOTFILES_DIR}/modules/home-manager/desktop"
mkdir -p "${DOTFILES_DIR}/modules/home-manager/programs/network"
mkdir -p "${DOTFILES_DIR}/templates/devshells/python"
mkdir -p "${DOTFILES_DIR}/templates/devshells/nodejs"
mkdir -p "${DOTFILES_DIR}/templates/devshells/rust"
mkdir -p "${DOTFILES_DIR}/docs"
mkdir -p "${DOTFILES_DIR}/configs/hyprland"
mkdir -p "${DOTFILES_DIR}/scripts"

echo -e "${GREEN}✓ Directories created${NC}"
echo

# Instructions for manual file creation
echo -e "${YELLOW}Please create the following files manually:${NC}"
echo
echo "1. Security Module:"
echo "   ${DOTFILES_DIR}/modules/nixos/system/security.nix"
echo
echo "2. Maintenance Module:"
echo "   ${DOTFILES_DIR}/modules/nixos/system/maintenance.nix"
echo
echo "3. Backup Module:"
echo "   ${DOTFILES_DIR}/modules/home-manager/services/backup.nix"
echo
echo "4. Notifications Module:"
echo "   ${DOTFILES_DIR}/modules/home-manager/desktop/notifications.nix"
echo
echo "5. Network Module:"
echo "   ${DOTFILES_DIR}/modules/home-manager/programs/network/default.nix"
echo
echo "6. Hyprland Additions:"
echo "   ${DOTFILES_DIR}/configs/hyprland/hyprland-additions.conf"
echo
echo "7. Scripts:"
echo "   ${DOTFILES_DIR}/scripts/system-monitor.sh"
echo "   ${DOTFILES_DIR}/scripts/power-menu.sh"
echo "   ${DOTFILES_DIR}/scripts/rollback.sh"
echo
echo "8. Development Shell Templates:"
echo "   ${DOTFILES_DIR}/templates/devshells/python/flake.nix"
echo "   ${DOTFILES_DIR}/templates/devshells/nodejs/flake.nix"
echo "   ${DOTFILES_DIR}/templates/devshells/rust/flake.nix"
echo "   ${DOTFILES_DIR}/templates/README.md"
echo
echo "9. Documentation:"
echo "   ${DOTFILES_DIR}/docs/TROUBLESHOOTING.md"
echo
echo -e "${BLUE}After creating the files, follow these steps:${NC}"
echo
echo "1. Update module imports:"
echo "   Edit ${DOTFILES_DIR}/modules/home-manager/default.nix"
echo "   Add: ./services/backup.nix"
echo "   Add: ./programs/network"
echo
echo "2. Update desktop module imports:"
echo "   Edit ${DOTFILES_DIR}/modules/home-manager/desktop/default.nix"
echo "   Add: ./notifications.nix"
echo
echo "3. Make scripts executable:"
echo "   chmod +x ${DOTFILES_DIR}/scripts/*.sh"
echo
echo "4. Add Hyprland additions to main config:"
echo "   Add this line to ${DOTFILES_DIR}/configs/hyprland/hyprland.conf:"
echo "   source = ~/.dotfiles/configs/hyprland/hyprland-additions.conf"
echo
echo "5. Test configuration:"
echo "   cd ${DOTFILES_DIR}"
echo "   make check"
echo
echo "6. Apply changes:"
echo "   make switch-system"
echo "   make switch-home"
echo
echo -e "${GREEN}✓ Setup instructions complete!${NC}"
