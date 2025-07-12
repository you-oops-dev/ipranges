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


python utils/arin-org.py SKYCA-3 >> /tmp/fastly.txt
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://api.fastly.com/public-ip-list| jq -r '.addresses[], .ipv6_addresses[]' >> /tmp/fastly.txt || echo 'failed'
get_routes 'AS54113' >> /tmp/fastly.txt || echo 'failed'
get_routes 'AS895' >> /tmp/fastly.txt || echo 'failed'

# save ipv4
grep -v ':' /tmp/fastly.txt > /tmp/fastly-ipv4.txt

# save ipv6
grep ':' /tmp/fastly.txt > /tmp/fastly-ipv6.txt


# sort & uniq
sort -h /tmp/fastly-ipv4.txt | uniq > fastly/ipv4.txt
sort -h /tmp/fastly-ipv6.txt | uniq > fastly/ipv6.txt
