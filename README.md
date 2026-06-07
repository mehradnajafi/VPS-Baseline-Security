# VPS Baseline Security & Cloudflare Routing

A straightforward Bash script I wrote to harden fresh Linux (Ubuntu/Debian) servers. 

## 🧠 Why I built this
While studying routing and messing with Cloudflare for my personal projects, I realized a major security flaw: if you proxy a website through Cloudflare, attackers can still scan the internet, find your server's true IP, and hit it directly (bypassing the Cloudflare WAF entirely). 

This script automates the fix. It locks down the UFW (Uncomplicated Firewall) so that ports 80 and 443 only accept incoming traffic from Cloudflare's official IP ranges.

## ⚙️ What the script does:
1. Sets default UFW rules (deny all incoming, allow all outgoing).
2. Keeps SSH access open (so we don't lock ourselves out).
3. Automatically fetches the latest IPv4 and IPv6 lists directly from Cloudflare's API.
4. Whitelists those specific IPs for web traffic.
5. Enables the firewall.

## 🚀 Usage

Run this on a fresh Ubuntu/Debian machine as root or with sudo:

```bash
git clone [https://github.com/mehradnajafi/vps-baseline-security.git](https://github.com/mehradnajafi/vps-baseline-security.git)
cd vps-baseline-security
chmod +x setup.sh
sudo ./setup.sh
