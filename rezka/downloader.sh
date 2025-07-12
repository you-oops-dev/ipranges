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

get_routes 'AS48158' > /tmp/rezka.txt || echo 'failed'
get_routes 'AS58073' >> /tmp/rezka.txt || echo 'failed'

dos2unix rezka/domain.txt &>/dev/null;
cat rezka/domain.txt | utils/mdig-bolvan --family=4 --threads=$(nproc) | sed '/[A-Za-z]/d' | sed 's/ //g' | sed '/^0.0.0.0/d' | sed '/^127.0.0.1/d' | grepcidr -v '0.0.0.0/8' | grepcidr -v '0.0.0.0/32' | grepcidr -v '10.0.0.0/8' | grepcidr -v '100.64.0.0/10' | grepcidr -v '127.0.0.0/8' | grepcidr -v '169.254.0.0/16' | grepcidr -v '172.16.0.0/12' | grepcidr -v '192.0.0.0/24' | grepcidr -v '192.0.0.0/29' | grepcidr -v '192.0.0.170/32' | grepcidr -v '192.0.0.171/32' | grepcidr -v '192.0.2.0/24' | grepcidr -v '192.88.99.0/24' | grepcidr -v '192.88.99.1/32' | grepcidr -v '192.168.0.0/16' | grepcidr -v '198.51.100.0/24' | grepcidr -v '198.18.0.0/15' | grepcidr -v '203.0.113.0/24' | grepcidr -v '224.0.0.0/4' | grepcidr -v '240.0.0.0/4' | grepcidr -v '255.255.255.255/32' > /tmp/arch.txt
cat rezka/domain.txt | utils/mdig-bolvan --family=6 --threads=$(nproc) | grep ":" >> /tmp/rezka.txt

# save ipv4
grep -v ':' /tmp/rezka.txt > /tmp/rezka-ipv4.txt

# save ipv6
grep ':' /tmp/rezka.txt > /tmp/rezka-ipv6.txt


# sort & uniq
sort -h /tmp/rezka-ipv4.txt | uniq > rezka/ipv4.txt
sort -h /tmp/rezka-ipv6.txt | uniq > rezka/ipv6.txt
