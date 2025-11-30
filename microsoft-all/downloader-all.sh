#!/bin/bash

set -euo pipefail
set -x

name_dir=microsoft-all

# get Microsoft and Azure list unmerged
name_list1=microsoft
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/refs/heads/main/$name_list1/ipv4.txt.zst | zstd -d > ${name_dir}/ipv4.txt
name_list2=azure
curl --max-time 30 --retry-delay 3 --retry 10 -4s -# https://raw.githubusercontent.com/$NAME_ACCOUNT_GITHUB/ipranges/refs/heads/main/$name_list2/ipv4.txt.zst | zstd -d >> ${name_dir}/ipv4.txt
# sorting address
sort -t. -k1,1n -k2,2n -k3,3n -k4,4n ${name_dir}/ipv4.txt | uniq | sponge ${name_dir}/ipv4.txt

# usage Mat1RX
python utils/merge_Mat1RX.py -c 1000000 --source=${name_dir}/ipv4.txt | sort -h > ${name_dir}/ipv4_merged.txt
# usage ip2net
cat ${name_dir}/ipv4.txt | utils/ip2net-static --v4-threshold=${THRESHOLDv4} --prefix-length=${IP2NET_PREFIX_LENGTH} | sort -h > ${name_dir}/ipv4_smart.txt

# clean unmerged list
rm -f ${name_dir}/ipv4.txt;
