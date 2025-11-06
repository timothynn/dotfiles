#!/usr/bin/env bash
# Complete NixOS Configuration Setup Script
# Run this after creating all the files

set -e

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║        NixOS Complete Configuration Setup Script              ║"
echo "║        Intel i5-6300U Laptop Configuration                    ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "❌ Please do not run as root"
   exit 1
fi

# Create dotfiles directory if it doesn't exist
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "📁 Creating $DOTFILES_DIR..."
    mkdir -p "$DOTFILES_DIR"
else
    echo "✅ Dotfiles directory exists"
fi

cd "$DOTFILES_DIR"

# Create directory structure
echo ""
echo "📂 Creating directory structure..."

mkdir -p hosts/nixos
mkdir -p home/tim
mkdir -p modules/nixos/{desktop,programs,services,system}
mkdir -p modules/home-manager/{desktop,programs,services,theming}
mkdir -p modules/home-manager/programs/{browser,communication,development,data-science,backend,editor,media,productivity,shell,terminal,utilities}
mkdir -p configs/{hyprland,waybar,docker-compose,nginx}
mkdir -p scripts
mkdir -p backup

echo "✅ Directory structure created"

# Backup existing hardware-configuration.nix if it exists
if [ -f "/etc/nixos/hardware-configuration.nix" ]; then
    echo ""
    echo "💾 Backing up hardware-configuration.nix..."
    sudo cp /etc/nixos/hardware-configuration.nix "$DOTFILES_DIR/hardware-configuration.nix"
    echo "✅ Hardware configuration backed up"
else
    echo "⚠️  Warning: /etc/nixos/hardware-configuration.nix not found"
    echo "   You'll need to generate it with: sudo nixos-generate-config"
fi

# Check if flake.nix exists
if [ ! -f "$DOTFILES_DIR/flake.nix" ]; then
    echo ""
    echo "⚠️  Warning: flake.nix not found in $DOTFILES_DIR"
    echo "   Please ensure all files are created before running this script"
fi

# Set proper permissions for scripts
echo ""
echo "🔐 Setting script permissions..."
if [ -d "$DOTFILES_DIR/scripts" ]; then
    chmod +x "$DOTFILES_DIR/scripts"/*.sh 2>/dev/null || true
    chmod +x "$DOTFILES_DIR/scripts"/*.py 2>/dev/null || true
    echo "✅ Script permissions set"
fi

# Initialize git repository if not already initialized
if [ ! -d "$DOTFILES_DIR/.git" ]; then
    echo ""
    echo "🔧 Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: Complete NixOS configuration for Intel i5-6300U laptop"
    echo "✅ Git repository initialized"
else
    echo "✅ Git repository already exists"
fi

# Validate flake syntax
echo ""
echo "🔍 Validating flake configuration..."
if nix flake metadata "$DOTFILES_DIR" &>/dev/null; then
    echo "✅ Flake syntax is valid"
else
    echo "❌ Flake has syntax errors. Please check flake.nix"
    exit 1
fi

# Summary
echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    Setup Complete! 🎉                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1️⃣  Review your configuration:"
echo "   cd $DOTFILES_DIR"
echo "   make check"
echo ""
echo "2️⃣  Update git configuration in:"
echo "   modules/home-manager/programs/development/git.nix"
echo ""
echo "3️⃣  Build the system (first time may take a while):"
echo "   sudo nixos-rebuild switch --flake .#nixos"
echo ""
echo "4️⃣  Build home-manager:"
echo "   home-manager switch --flake .#tim@nixos"
echo ""
echo "5️⃣  Reboot your system:"
echo "   sudo reboot"
echo ""
echo "6️⃣  After reboot, start databases as needed:"
echo "   sudo systemctl start postgresql"
echo "   sudo systemctl start redis"
echo "   sudo systemctl start mongodb"
echo ""
echo "⚡ Performance Notes for your laptop:"
echo "   - TLP is enabled for battery optimization"
echo "   - CPU governor: powersave on battery, performance on AC"
echo "   - Zram: 50% of RAM (~3.7GB compressed swap)"
echo "   - Database services start manually to save resources"
echo ""
echo "🎨 Theme: Catppuccin Mocha throughout"
echo "   - GRUB bootloader with theme"
echo "   - SDDM login screen"
echo "   - Hyprland, Waybar, Kitty"
echo "   - All applications"
echo ""
echo "📚 Useful commands:"
echo "   nrs  - Rebuild NixOS system"
echo "   hms  - Rebuild home-manager"
echo "   make check - Validate config"
echo "   make clean - Clean old generations"
echo ""
echo "Happy coding! 🚀"
