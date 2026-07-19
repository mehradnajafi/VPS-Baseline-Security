#!/bin/bash

# Cloudflare Origin Firewall Baseline for Linux VPS
# Author: Mehrad Najafi
# Description: Restricts inbound HTTP/HTTPS traffic to Cloudflare's published
# IP ranges using UFW.

echo "[*] Starting Cloudflare origin firewall configuration..."

echo "[*] Starting the hardening process..."

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
curl -s https://www.cloudflare.com/ips-v4 > /tmp/cf_ips
echo "" >> /tmp/cf_ips
curl -s https://www.cloudflare.com/ips-v6 >> /tmp/cf_ips

echo "[*] Applying Cloudflare IPs to firewall..."
for ip in $(cat /tmp/cf_ips); do
    ufw allow proto tcp from $ip to any port 80,443
done

# Clean up temp file
rm /tmp/cf_ips

# 4. Enable firewall
echo "[*] Enabling UFW..."
ufw --force enable

echo "[+] Done! Server is now locked down. Web traffic is only allowed via Cloudflare."
