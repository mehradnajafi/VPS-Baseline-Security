# Cloudflare Origin Firewall Baseline for Linux VPS

A focused Bash and UFW baseline for restricting direct HTTP and HTTPS access to Cloudflare-proxied Linux servers.

The current scope is limited to Cloudflare origin firewall rules. It is not a complete VPS-hardening solution. 

## Why I Built This

When a DNS record is proxied through Cloudflare, normal clients connect to Cloudflare instead of connecting directly to the origin server.

However, if the origin IP address is already known or exposed through historical DNS records, another service, or an older configuration, ports 80 and 443 may still accept direct connections.

This project focuses on one network-layer control: allowing HTTP and HTTPS traffic from Cloudflare's published IP ranges while blocking other direct web traffic at the origin firewall.

This script automates the fix. It locks down the UFW (Uncomplicated Firewall) so that ports 80 and 443 only accept incoming traffic from Cloudflare's official IP ranges.

## ⚙️ What the script does:
1. Sets default UFW rules (deny all incoming, allow all outgoing).
2. Keeps SSH access open (so we don't lock ourselves out).
3. Downloads Cloudflare's published IPv4 and IPv6 ranges.
4. Whitelists those specific IPs for web traffic.
5. Enables the firewall.


## 🚀 Usage

Run this on a fresh Ubuntu/Debian machine as root or with sudo:

```bash
git clone [https://github.com/mehradnajafi/vps-baseline-security.git](https://github.com/mehradnajafi/vps-baseline-security.git)
cd vps-baseline-security
chmod +x setup.sh
sudo ./setup.sh
