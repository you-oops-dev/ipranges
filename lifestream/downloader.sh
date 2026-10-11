#!/bin/bash

#set -euo pipefail
#set -x


# get from Autonomous System
get_maintained() {
    whois -h whois.ripe.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.radb.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h rr.ntt.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.rogerstelecom.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.bgp.net.br -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
}

get_maintained 'LIFESTREAM-MNT' | grep -v 'route-set' | grep "/" > /tmp/lifestream.txt || echo 'failed'


# save ipv4
grep -v ':' /tmp/lifestream.txt > /tmp/lifestream-ipv4.txt

# save ipv6
grep ':' /tmp/lifestream.txt > /tmp/lifestream-ipv6.txt


# sort & uniq
sort -h /tmp/lifestream-ipv4.txt | uniq > lifestream/ipv4.txt
sort -h /tmp/lifestream-ipv6.txt | uniq > lifestream/ipv6.txt
