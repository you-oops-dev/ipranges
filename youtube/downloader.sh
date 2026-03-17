#!/bin/bash


set -euo pipefail
set -x

# save ipv4
#grep -v ':' youtube/nets.txt > /tmp/youtube-ipv4.txt
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/antonme/ipnames/refs/heads/master/resolve-youtube.txt | grep -i [0-9]. > /tmp/youtube-ipv4.txt || echo 'failed'
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/antonme/ipnames/refs/heads/master/ext-resolve-youtube.txt | grep -i [0-9]. >> /tmp/youtube-ipv4.txt || echo 'failed'
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/antonme/ipnames/refs/heads/master/dns-youtube.txt > youtube/domain.txt || echo "YouTube: Getting domain failed"
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/bol-van/zapret-win-bundle/refs/heads/master/zapret-winws/files/list-youtube.txt >> youtube/domain.txt || echo "YouTube: Getting domain 2 failed"
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/antonme/ipnames/master/ext-dns-youtube.txt >> youtube/domain.txt || echo "YouTube: Getting domain 3 failed"
curl -4s --max-time 90 --retry-delay 3 --retry 10 https://raw.githubusercontent.com/itdoginfo/allow-domains/refs/heads/main/Services/youtube.lst >> youtube/domain.txt || echo "YouTube: Getting domain 4 failed source itdoginfo"


echo "img.youtube.com
ggpht.com
ytimg.com
youtu.be
youtubei.googleapis.com
googleusercontent.com
yt3.ggpht.com
googlevideo.com
gstatic.com
googleapis.com
googleusercontent.com
youtube.com
sponsor.ajay.app
sponsorblock.hankmccord.dev
returnyoutubedislike.com
returnyoutubedislikeapi.com
music.youtube.com" >> youtube/domain.txt
dos2unix youtube/domain.txt
sort youtube/domain.txt | uniq | sponge youtube/domain.txt
cat youtube/domain.txt | grep -vEe '(.youtube.com|.ytimg.com|.google.com|.withgoogle.com|.googleusercontent.com|.metric.gstatic.com|.googleapis.com|.ggpht.com)$' > youtube/domain_prepare.txt
sort -h youtube/domain_prepare.txt | uniq | sed '/wwww/d' | sed '/kellykawase/d' | sed '/lscache/d' | sed '/preferred/d' | sed '/video.google.com/d' | sed '/hatenablog.co/d' | sed '/blogspot/d' | sed '/githubusercontent/d' | sed '/appspot/d' | sed '/kilatiron/d' | sed '/.ru$/d' | sed '/.co$/d' | sed '/.download$/d' | sed '/.yolasite.com$/d' | sed '/.youtube$/d' | sed '/.info$/d' | sed '/.me$/d' | sed '/.be$/d' | sed '/.net$/d' | sed '/.io$/d' | sed '/.ua$/d' | sed '/.cn$/d' | sort | sponge youtube/domain_prepare.txt
sort -h youtube/domain_prepare.txt | uniq | sponge youtube/domain_prepare.txt

mv -f youtube/domain_prepare.txt youtube/domain.txt

# Both Record (IPv4/IPv6)
#cat youtube/domain.txt | utils/mdig-bolvan --threads=$(nproc) >> /tmp/youtube-ipv4.txt
# A-Record (IPv4)
cat youtube/domain.txt | sort | uniq | utils/mdig-bolvan --family=4 --threads=$(nproc) >> /tmp/youtube-ipv4.txt || echo "YouTube IPv4: failed"
# AAAA-Record (IPv6)
#cat youtube/domain.txt | utils/mdig-bolvan --family=6 --threads=$(nproc) >> /tmp/youtube-ipv6.txt || echo "YouTube IPv6: failed"

# save ipv6
# grep ':' youtube/nets.txt > /tmp/youtube-ipv6.txt

# sort & uniq
sort -h /tmp/youtube-ipv4.txt | uniq > youtube/ipv4.txt
# sort -h /tmp/youtube-ipv6.txt | uniq > youtube/ipv6.txt
