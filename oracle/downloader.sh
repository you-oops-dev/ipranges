#!/bin/bash

# https://docs.oracle.com/en-us/iaas/Content/General/Concepts/addressranges.htm
# From: https://github.com/nccgroup/cloud_ip_ranges

set -euo pipefail
set -x


# get from public ranges
curl -4s --max-time 90 --retry-delay 3 --retry 5 https://docs.oracle.com/en-us/iaas/tools/public_ip_ranges.json > /tmp/oracle.json


# save ipv4
jq '.regions[] | [.cidrs][] | .[].cidr | select(. != null)' -r /tmp/oracle.json > /tmp/oracle-ipv4.txt

# ipv6 not provided


# sort & uniq
sort -h /tmp/oracle-ipv4.txt | uniq > oracle/ipv4.txt
