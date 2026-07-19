#!/bin/bash
set -euo pipefail

# Cloudflare Origin Firewall Baseline for Linux VPS
# Author: Mehrad Najafi
# Description: Restricts inbound HTTP/HTTPS traffic to Cloudflare's published
# IP ranges using UFW.

echo "[*] Starting Cloudflare origin firewall configuration..."

# 1. Update package list
echo "[*] Updating system packages..."
apt-get update -qq

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

# Clean up temp file
rm /tmp/cf_ips

# 4. Enable firewall
echo "[*] Enabling UFW..."
ufw --force enable

echo "[+] Cloudflare origin firewall rules applied. HTTP/HTTPS access is limited to Cloudflare IP ranges."
