#!/bin/bash


set -euo pipefail
set -x


# get from Autonomous System
get_routes() {
    whois -h riswhois.ripe.net -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.radb.net -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
    whois -h rr.ntt.net -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.rogerstelecom.net -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.bgp.net.br -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
}

get_routes 'AS21785' > /tmp/redhat.txt || echo 'failed'

# save ipv4
grep -v ':' /tmp/redhat.txt > /tmp/redhat-ipv4.txt

# save ipv6
grep ':' /tmp/redhat.txt > /tmp/redhat-ipv6.txt


# sort & uniq
sort -h /tmp/redhat-ipv4.txt | uniq > redhat/ipv4.txt
sort -h /tmp/redhat-ipv6.txt | uniq > redhat/ipv6.txt
