#!/bin/bash

#set -euo pipefail
#set -x


# get from mnt
get_maintained() {
    whois -h whois.ripe.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.radb.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h rr.ntt.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.rogerstelecom.net -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.bgp.net.br -- "-i mnt-by $1" | rg '^route' | awk '{ print $2; }'
}

# get from Autonomous System
get_routes() {
    whois -h riswhois.ripe.net -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.radb.net -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
    whois -h rr.ntt.net -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.rogerstelecom.net -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
    whois -h whois.bgp.net.br -- "-i origin $1" | rg '^route' | awk '{ print $2; }'
}

#get_maintained 'PASTE-MNT' > /tmp/roblox.txt || echo 'failed'
get_routes 'AS22697' > /tmp/roblox.txt || echo 'failed'

dos2unix roblox/domain.txt
rm -f /tmp/roblox_resolve.txt;
# resolving
# Both Record (IPv4/IPv6)
cat roblox/domain.txt | utils/mdig-bolvan --threads=$(nproc) >> /tmp/roblox_resolve.txt
# A-Record (IPv4)
#cat roblox/domain.txt | utils/mdig-bolvan --family=4 --threads=$(nproc) >> /tmp/roblox_resolve.txt
# AAAA-Record (IPv6)
#cat roblox/domain.txt | utils/mdig-bolvan --family=6 --threads=$(nproc) >> /tmp/roblox_resolve.txt
cat /tmp/roblox.txt /tmp/roblox_resolve.txt | uniq | sort -u | sed '/^0.0.0.0/d' | sed '/^127.0.0.1/d' | sed '/^1.1.1.1/d' | sed '/^8.8.8.8/d' | sed '/^1.0.0.1/d' | sed '/^8.8.4.4/d' | sponge /tmp/roblox.txt

# save ipv4
grep -v ':' /tmp/roblox.txt | sed '/[A-Za-z]/d' | sed 's/ //g' | sed '/^0.0.0.0/d' | sed '/^127.0.0.1/d' | sed '/^1.1.1.1/d' | sed '/^8.8.8.8/d' | sed '/^1.0.0.1/d' | sed '/^8.8.4.4/d' | grepcidr -v '0.0.0.0/8' | grepcidr -v '0.0.0.0/32' | grepcidr -v '10.0.0.0/8' | grepcidr -v '100.64.0.0/10' | grepcidr -v '127.0.0.0/8' | grepcidr -v '169.254.0.0/16' | grepcidr -v '172.16.0.0/12' | grepcidr -v '192.0.0.0/24' | grepcidr -v '192.0.0.0/29' | grepcidr -v '192.0.0.170/32' | grepcidr -v '192.0.0.171/32' | grepcidr -v '192.0.2.0/24' | grepcidr -v '192.88.99.0/24' | grepcidr -v '192.88.99.1/32' | grepcidr -v '192.168.0.0/16' | grepcidr -v '198.51.100.0/24' | grepcidr -v '198.18.0.0/15' | grepcidr -v '203.0.113.0/24' | grepcidr -v '224.0.0.0/4' | grepcidr -v '240.0.0.0/4' | grepcidr -v '255.255.255.255/32' > /tmp/roblox-ipv4.txt

# save ipv6
grep ':' /tmp/roblox.txt | sed 's/ //g' | sed '/^$/d' | uniq | sort -u > /tmp/roblox-ipv6.txt

# sort & uniq
sort -k1,1n -k2,2n -k3,3n -k4,4n -T /tmp -h /tmp/roblox-ipv4.txt | uniq > roblox/ipv4.txt
sort -T /tmp -h /tmp/roblox-ipv6.txt | uniq > roblox/ipv6.txt

