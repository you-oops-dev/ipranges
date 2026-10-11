#!/bin/bash


# https://www.irr.net/docs/list.html
# https://bgp.he.net/search?search%5Bsearch%5D=tiktok&commit=Search
# https://github.com/SecOps-Institute/TwitterIPLists/blob/master/tiktok_asn_list.lst

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

get_routes 'AS138699' > /tmp/tiktok.txt || echo 'failed'

python utils/arin-org.py BYTED >> /tmp/tiktok.txt
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://raw.githubusercontent.com/antonme/ipnames/master/resolve-tiktok.txt | grep -i [0-9]. >> /tmp/tiktok.txt || echo 'failed'
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://raw.githubusercontent.com/antonme/ipnames/master/ext-resolve-tiktok.txt | grep -i [0-9]. >> /tmp/tiktok.txt || echo 'failed'

dos2unix tiktok/domain.txt &>/dev/null;
cat tiktok/domain.txt | utils/mdig-bolvan --family=4 --threads=$(nproc) | sed '/[A-Za-z]/d' | sed 's/ //g' | sed '/^0.0.0.0/d' | sed '/^127.0.0.1/d' | grepcidr -v '0.0.0.0/8' | grepcidr -v '0.0.0.0/32' | grepcidr -v '10.0.0.0/8' | grepcidr -v '100.64.0.0/10' | grepcidr -v '127.0.0.0/8' | grepcidr -v '169.254.0.0/16' | grepcidr -v '172.16.0.0/12' | grepcidr -v '192.0.0.0/24' | grepcidr -v '192.0.0.0/29' | grepcidr -v '192.0.0.170/32' | grepcidr -v '192.0.0.171/32' | grepcidr -v '192.0.2.0/24' | grepcidr -v '192.88.99.0/24' | grepcidr -v '192.88.99.1/32' | grepcidr -v '192.168.0.0/16' | grepcidr -v '198.51.100.0/24' | grepcidr -v '198.18.0.0/15' | grepcidr -v '203.0.113.0/24' | grepcidr -v '224.0.0.0/4' | grepcidr -v '240.0.0.0/4' | grepcidr -v '255.255.255.255/32' >> /tmp/tiktok.txt
cat tiktok/domain.txt | utils/mdig-bolvan --family=6 --threads=$(nproc) | grep ":" >> /tmp/tiktok.txt

# save ipv4
grep -v ':' /tmp/tiktok.txt | grep -v "0.0.0.0" > /tmp/tiktok-ipv4.txt
sed -i '/^0.0.0.0/d' /tmp/tiktok-ipv4.txt
sed -i '/^127.0.0.1/d' /tmp/tiktok-ipv4.txt

# save ipv6
grep ':' /tmp/tiktok.txt > /tmp/tiktok-ipv6.txt


# sort & uniq
sort -h /tmp/tiktok-ipv4.txt | uniq > tiktok/ipv4.txt
sort -h /tmp/tiktok-ipv6.txt | uniq > tiktok/ipv6.txt
