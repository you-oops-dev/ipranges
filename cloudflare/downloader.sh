#!/bin/bash


set -euo pipefail
set -x

curl -4s --max-time 90 --retry-delay 3 --retry 5 https://www.cloudflare.com/ips-v4 > cloudflare/ipv4.txt
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://www.cloudflare.com/ips-v6 > cloudflare/ipv6.txt

echo >> cloudflare/ipv4.txt
echo >> cloudflare/ipv6.txt
