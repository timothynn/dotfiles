#!/usr/bin/env bash
# Rollback system or home-manager to previous generation

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
BOLD='\033[1m'

show_help() {
    echo "Usage: $(basename "$0") [system|home] [OPTIONS]"
    echo ""
    echo "Rollback NixOS system or Home Manager to a previous generation"
    echo ""
    echo "Commands:"
    echo "  system              Rollback NixOS system configuration"
    echo "  home                Rollback Home Manager configuration"
    echo ""
    echo "Options:"
    echo "  -l, --list          List available generations"
    echo "  -n, --number NUM    Rollback to specific generation number"
    echo "  -h, --help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  $(basename "$0") system --list"
    echo "  $(basename "$0") system --number 42"
    echo "  $(basename "$0") home"
}

list_system_generations() {
    echo -e "${BLUE}${BOLD}System Generations:${NC}"
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -20
}

list_home_generations() {
    echo -e "${BLUE}${BOLD}Home Manager Generations:${NC}"
    home-manager generations | head -20
}

rollback_system() {
    local generation="$1"
    
    if [ -n "$generation" ]; then
        echo -e "${YELLOW}Rolling back system to generation $generation...${NC}"
        sudo nix-env --switch-generation "$generation" --profile /nix/var/nix/profiles/system
        sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
    else
        echo -e "${YELLOW}Rolling back system to previous generation...${NC}"
        sudo nixos-rebuild switch --rollback
    fi
    
    echo -e "${GREEN}✓ System rollback completed!${NC}"
}

rollback_home() {
    local generation="$1"
    
    if [ -n "$generation" ]; then
        echo -e "${YELLOW}Rolling back home-manager to generation $generation...${NC}"
        home-manager generations | grep "id $generation" | awk '{print $NF}' | while read path; do
            "$path/activate"
        done
    else
        echo -e "${YELLOW}Rolling back home-manager to previous generation...${NC}"
        home-manager generations | head -2 | tail -1 | awk '{print $NF}' | while read path; do
            "$path/activate"
        done
    fi
    
    echo -e "${GREEN}✓ Home Manager rollback completed!${NC}"
}

# Parse arguments
TYPE=""
ACTION="rollback"
GENERATION=""

while [[ $# -gt 0 ]]; do
    case $1 in
        system|home)
            TYPE="$1"
            shift
            ;;
        -l|--list)
            ACTION="list"
            shift
            ;;
        -n|--number)
            GENERATION="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Validate type
if [ -z "$TYPE" ]; then
    echo -e "${RED}Error: Must specify 'system' or 'home'${NC}"
    echo ""
    show_help
    exit 1
fi

# Execute action
case "$ACTION" in
    list)
        if [ "$TYPE" = "system" ]; then
            list_system_generations
        else
            list_home_generations
        fi
        ;;
    rollback)
        if [ "$TYPE" = "system" ]; then
            rollback_system "$GENERATION"
        else
            rollback_home "$GENERATION"
        fi
        ;;
esac
