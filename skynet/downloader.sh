#!/bin/bash

set -euo pipefail
set -x


# get from Autonomous System
get_maintained() {
    whois -h whois.ripe.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.radb.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h rr.ntt.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.rogerstelecom.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.bgp.net.br -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
}

get_maintained 'MNT-SKNT' | grep -v 'route-set' | grep "/" > /tmp/skynet.txt || echo 'failed'


# save ipv4
grep -v ':' /tmp/skynet.txt > /tmp/skynet-ipv4.txt

# save ipv6
grep ':' /tmp/skynet.txt > /tmp/skynet-ipv6.txt


# sort & uniq
sort -h /tmp/skynet-ipv4.txt | uniq > skynet/ipv4.txt
sort -h /tmp/skynet-ipv6.txt | uniq > skynet/ipv6.txt
