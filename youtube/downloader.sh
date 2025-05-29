#!/bin/bash


set -euo pipefail
set -x



# save ipv4
#grep -v ':' youtube/nets.txt > /tmp/youtube-ipv4.txt
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://raw.githubusercontent.com/antonme/ipnames/refs/heads/master/resolve-youtube.txt | grep -i [0-9]. > /tmp/youtube-ipv4.txt || echo 'failed'
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://raw.githubusercontent.com/antonme/ipnames/refs/heads/master/ext-resolve-youtube.txt | grep -i [0-9]. >> /tmp/youtube-ipv4.txt || echo 'failed'
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://raw.githubusercontent.com/antonme/ipnames/refs/heads/master/dns-youtube.txt >> youtube/domain.txt || echo "YouTube: Getting domain failed"
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://raw.githubusercontent.com/bol-van/zapret-win-bundle/refs/heads/master/zapret-winws/files/list-youtube.txt >> youtube/domain.txt || echo "YouTube: Getting domain 2 failed"
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://raw.githubusercontent.com/itdoginfo/allow-domains/refs/heads/main/Services/youtube.lst >> youtube/domain.txt || echo "YouTube: Getting domain 3 failed source itdoginfo"
# Both Record (IPv4/IPv6)
#cat youtube/domain.txt | utils/mdig-bolvan --threads=$(nproc) >> /tmp/youtube-ipv4.txt
# A-Record (IPv4)
cat youtube/domain.txt | sort | uniq | utils/mdig-bolvan --family=4 --threads=$(nproc) >> /tmp/youtube-ipv4.txt || echo "YouTube IPv4: failed"
# AAAA-Record (IPv6)
#cat youtube/domain.txt | utils/mdig-bolvan --family=6 --threads=$(nproc) >> /tmp/youtube-ipv6.txt || echo "YouTube IPv6: failed"

# save ipv6
# grep ':' youtube/nets.txt > /tmp/youtube-ipv6.txt


# sort & uniq
sort -h /tmp/youtube-ipv4.txt | uniq > youtube/ipv4.txt
# sort -h /tmp/youtube-ipv6.txt | uniq > youtube/ipv6.txt
