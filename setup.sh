#!/bin/bash
set -euo pipefail

# Cloudflare Origin Firewall Baseline for Linux VPS
# Author: Mehrad Najafi
# Description: Restricts inbound HTTP/HTTPS traffic to Cloudflare's published
# IP ranges using UFW.

echo "[*] Starting Cloudflare origin firewall configuration..."

# 1. Update package list
if [[ $EUID -ne 0 ]]; then
    echo "[!] Run this script as root or with sudo."
    exit 1
fi

for command in ufw curl mktemp; do
    if ! command -v "$command" >/dev/null 2>&1; then
        echo "[!] Required command not found: $command"
        exit 1
    fi
done

# 2. Setup baseline UFW (Firewall) rules
echo "[*] Setting up UFW basics..."
ufw default deny incoming
ufw default allow outgoing

# Always allow SSH first! Don't lock ourselves out
echo "[*] Allowing SSH..."
ufw allow ssh

# 3. Fetch latest Cloudflare IPs and whitelist them
echo "[*] Fetching Cloudflare IP ranges..."

# Download IPv4 & IPv6 lists
CF_IPS=$(mktemp)
trap 'rm -f "$CF_IPS"' EXIT

curl -fsS https://www.cloudflare.com/ips-v4 > "$CF_IPS"
curl -fsS https://www.cloudflare.com/ips-v6 >> "$CF_IPS"

if [[ ! -s "$CF_IPS" ]]; then
    echo "[!] Failed to download Cloudflare IP ranges."
    exit 1
fi

echo "[*] Applying Cloudflare IPs to firewall..."
while IFS= read -r ip; do
    [[ -z "$ip" ]] && continue

    ufw allow proto tcp from "$ip" to any port 80
    ufw allow proto tcp from "$ip" to any port 443
done < "$CF_IPS"


# 4. Enable firewall
echo "[*] Enabling UFW..."
ufw --force enable

echo "[+] Cloudflare IP-based HTTP/HTTPS rules were added."
echo "[*] Review all active rules with: ufw status numbered"
