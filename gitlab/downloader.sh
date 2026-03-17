#!/bin/bash

#set -euo pipefail
#set -x

curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/v2fly/domain-list-community/master/data/gitlab | sed 's/ //g' | sed -r '/^\s*$/d' | sed '/!/d' | sed '/!!/d' | sed '/#/d' | sed 's/DOMAIN-SUFFIX,//g' | sed 's/^https\?:\/\///g' | sed 's/full://g' | sed '/IP-CIDR/d' | sed '/@/d' | sed '/:/d' > gitlab/domains.txt
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/Shadowrocket/GitLab/GitLab.list | sed 's/ //g' | sed -r '/^\s*$/d' | sed '/!/d' | sed '/!!/d' | sed '/#/d' | sed 's/DOMAIN-SUFFIX,//g' | sed 's/^https\?:\/\///g' | sed '/IP-CIDR/d' | sed '/@/d' | sed 's/full://g' | sed '/:/d' | sed 's/DOMAIN,//g' | sed '/DOMAIN-KEYWORD/d' >> gitlab/domains.txt

dos2unix gitlab/domains.txt &>/dev/null;

sort gitlab/domains.txt | uniq | sponge gitlab/domains.txt

cat gitlab/domains.txt | utils/mdig-bolvan --family=4 --threads=$(nproc) | sed '/[A-Za-z]/d' | sed 's/ //g' | sed '/^0.0.0.0/d' | sed '/^127.0.0.1/d' | grepcidr -v '0.0.0.0/8' | grepcidr -v '0.0.0.0/32' | grepcidr -v '10.0.0.0/8' | grepcidr -v '100.64.0.0/10' | grepcidr -v '127.0.0.0/8' | grepcidr -v '169.254.0.0/16' | grepcidr -v '172.16.0.0/12' | grepcidr -v '192.0.0.0/24' | grepcidr -v '192.0.0.0/29' | grepcidr -v '192.0.0.170/32' | grepcidr -v '192.0.0.171/32' | grepcidr -v '192.0.2.0/24' | grepcidr -v '192.88.99.0/24' | grepcidr -v '192.88.99.1/32' | grepcidr -v '192.168.0.0/16' | grepcidr -v '198.51.100.0/24' | grepcidr -v '198.18.0.0/15' | grepcidr -v '203.0.113.0/24' | grepcidr -v '224.0.0.0/4' | grepcidr -v '240.0.0.0/4' | grepcidr -v '255.255.255.255/32' > /tmp/gitlab.txt
cat gitlab/domains.txt | utils/mdig-bolvan --family=6 --threads=$(nproc) | grep ":" >> /tmp/gitlab.txt

# save ipv4
grep -v ':' /tmp/gitlab.txt > /tmp/gitlab-ipv4.txt

# save ipv6
grep ':' /tmp/gitlab.txt > /tmp/gitlab-ipv6.txt

# sort & uniq
sort -t. -k1,1n -k2,2n -k3,3n -k4,4n -h /tmp/gitlab-ipv4.txt | uniq > gitlab/ipv4.txt
sort -h /tmp/gitlab-ipv6.txt | uniq > gitlab/ipv6.txt
