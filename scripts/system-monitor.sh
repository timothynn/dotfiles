#!/usr/bin/env bash
# System monitoring and health check script

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${BLUE}${BOLD}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}${BOLD}║                           SYSTEM HEALTH CHECK                                ║${NC}"
echo -e "${BLUE}${BOLD}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
echo

# Function to check status
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
    fi
}

# Disk Space
echo -e "${CYAN}${BOLD}Disk Space:${NC}"
df -h / /home | tail -n +2 | while read line; do
    usage=$(echo $line | awk '{print $5}' | sed 's/%//')
    mount=$(echo $line | awk '{print $6}')
    if [ "$usage" -gt 90 ]; then
        echo -e "${RED}  ⚠ $mount: ${usage}% used${NC}"
    elif [ "$usage" -gt 75 ]; then
        echo -e "${YELLOW}  ⚠ $mount: ${usage}% used${NC}"
    else
        echo -e "${GREEN}  ✓ $mount: ${usage}% used${NC}"
    fi
done
echo

# Memory Usage
echo -e "${CYAN}${BOLD}Memory Usage:${NC}"
mem_info=$(free -h | grep Mem)
mem_used=$(echo $mem_info | awk '{print $3}')
mem_total=$(echo $mem_info | awk '{print $2}')
mem_percent=$(free | grep Mem | awk '{print int($3/$2 * 100)}')
if [ "$mem_percent" -gt 90 ]; then
    echo -e "${RED}  ⚠ ${mem_used}/${mem_total} (${mem_percent}%)${NC}"
elif [ "$mem_percent" -gt 75 ]; then
    echo -e "${YELLOW}  ⚠ ${mem_used}/${mem_total} (${mem_percent}%)${NC}"
else
    echo -e "${GREEN}  ✓ ${mem_used}/${mem_total} (${mem_percent}%)${NC}"
fi
echo

# CPU Temperature
echo -e "${CYAN}${BOLD}CPU Temperature:${NC}"
if command -v sensors >/dev/null 2>&1; then
    sensors | grep -E "Core|Tdie|Package" | while read line; do
        temp=$(echo $line | grep -oP '\+\K[0-9]+' | head -1)
        if [ -n "$temp" ]; then
            if [ "$temp" -gt 80 ]; then
                echo -e "${RED}  ⚠ $line${NC}"
            elif [ "$temp" -gt 70 ]; then
                echo -e "${YELLOW}  ⚠ $line${NC}"
            else
                echo -e "${GREEN}  ✓ $line${NC}"
            fi
        fi
    done
else
    echo -e "${YELLOW}  ⚠ lm_sensors not installed${NC}"
fi
echo

# Disk Health (SMART)
echo -e "${CYAN}${BOLD}Disk Health:${NC}"
if command -v smartctl >/dev/null 2>&1; then
    for disk in /dev/sda /dev/nvme0n1; do
        if [ -b "$disk" ]; then
            health=$(sudo smartctl -H "$disk" 2>/dev/null | grep "SMART overall-health" | awk '{print $NF}')
            if [ "$health" = "PASSED" ]; then
                echo -e "${GREEN}  ✓ $disk: $health${NC}"
            else
                echo -e "${RED}  ✗ $disk: $health${NC}"
            fi
        fi
    done
else
    echo -e "${YELLOW}  ⚠ smartmontools not installed${NC}"
fi
echo

# Failed systemd services
echo -e "${CYAN}${BOLD}Failed Services:${NC}"
failed_services=$(systemctl --failed --no-legend | wc -l)
if [ "$failed_services" -eq 0 ]; then
    echo -e "${GREEN}  ✓ No failed services${NC}"
else
    echo -e "${RED}  ✗ $failed_services failed service(s):${NC}"
    systemctl --failed --no-legend | while read line; do
        echo -e "${RED}    - $line${NC}"
    done
fi
echo

# Journal errors (last hour)
echo -e "${CYAN}${BOLD}Recent Errors (last hour):${NC}"
error_count=$(journalctl -p err -S "1 hour ago" --no-pager | grep -c "^--" || true)
if [ "$error_count" -eq 0 ]; then
    echo -e "${GREEN}  ✓ No errors in the last hour${NC}"
else
    echo -e "${YELLOW}  ⚠ $error_count error(s) in the last hour${NC}"
    echo -e "${YELLOW}    Run: journalctl -p err -S '1 hour ago' to view${NC}"
fi
echo

# Nix store size
echo -e "${CYAN}${BOLD}Nix Store:${NC}"
store_size=$(du -sh /nix/store 2>/dev/null | awk '{print $1}')
echo -e "  📦 Store size: ${store_size}"
generations=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | wc -l)
echo -e "  📊 System generations: ${generations}"
echo

# Last garbage collection
echo -e "${CYAN}${BOLD}Last Garbage Collection:${NC}"
if [ -f /nix/var/nix/gcroots/auto/last-gc ]; then
    last_gc=$(stat -c %y /nix/var/nix/gcroots/auto/last-gc 2>/dev/null | cut -d' ' -f1)
    echo -e "  🗑️  Last GC: ${last_gc}"
else
    echo -e "${YELLOW}  ⚠ No GC information available${NC}"
fi
echo

# Network connectivity
echo -e "${CYAN}${BOLD}Network:${NC}"
if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Internet connectivity${NC}"
else
    echo -e "${RED}  ✗ No internet connectivity${NC}"
fi
echo

# Firewall status
echo -e "${CYAN}${BOLD}Firewall:${NC}"
if systemctl is-active --quiet firewall; then
    echo -e "${GREEN}  ✓ Firewall active${NC}"
else
    echo -e "${YELLOW}  ⚠ Firewall not running${NC}"
fi
echo

# Summary
echo -e "${BLUE}${BOLD}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}${BOLD}║                              HEALTH CHECK COMPLETE                           ║${NC}"
echo -e "${BLUE}${BOLD}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
