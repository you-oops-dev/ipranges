#!/bin/bash


export NICKNAME=hxehex
export REPO_NAME=russia-mobile-internet-whitelist
export FILE_NAME=cidrwhitelist.txt
export BRANCH=main
export URL=https://raw.githubusercontent.com/${NICKNAME}/${REPO_NAME}/refs/heads/${BRANCH}/${FILE_NAME}
export MIRROR=https://wget.la/${URL}
UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/112.0"

rm -f whitelist/ipv4.txt.zst;

curl -H "User-Agent: $UA" --max-time 30 --retry-delay 3 --retry 10 -4s ${URL} | grepcidr -v '0.0.0.0/8' | grepcidr -v '0.0.0.0/32' | grepcidr -v '10.0.0.0/8' | grepcidr -v '100.64.0.0/10' | grepcidr -v '127.0.0.0/8' | grepcidr -v '169.254.0.0/16' | grepcidr -v '172.16.0.0/12' | grepcidr -v '192.0.0.0/24' | grepcidr -v '192.0.0.0/29' | grepcidr -v '192.0.0.170/32' | grepcidr -v '192.0.0.171/32' | grepcidr -v '192.0.2.0/24' | grepcidr -v '192.88.99.0/24' | grepcidr -v '192.88.99.1/32' | grepcidr -v '192.168.0.0/16' | grepcidr -v '198.51.100.0/24' | grepcidr -v '198.18.0.0/15' | grepcidr -v '203.0.113.0/24' | grepcidr -v '224.0.0.0/4' | grepcidr -v '240.0.0.0/4' | grepcidr -v '255.255.255.255/32' | zstd -o whitelist/ipv4.txt.zst

zstdcat whitelist/ipv4.txt.zst > whitelist/ipv4.txt

python utils/merge_Mat1RX.py -c 1000000 --source=whitelist/ipv4.txt > whitelist/ipv4_merged.txt && rm -f  whitelist/ipv4.txt


