#! /usr/bin/sh

# not as fast or robust as arp-scan, but fuck external utilities

#export subnet="$(hostname -I | cut --delimiter='.' -f1,2,3)"
export subnet="192.168.1"
echo "pinging everything on subnet $subnet.0\\24"
subnet_range="$(seq 2 254)"

do_ping() {
  ip="${subnet}.${1}"
  ping -c 1 -W 0.01 $ip 2>&1 1>/dev/null ; result="$?"
  if [ $result == 0 ]; then 
    echo "host found on $ip"
  else 
    printf "."
  fi
}

export -f do_ping

# i am a dirty woman
parallel -j252 do_ping ::: "${subnet_range}"

# for i in $subnet_range; do
#   ip="${subnet}.${i}"
#   len="${#ip}"
#   # ping once and wait one second for it.
#   printf "$ip"
#   ping -c 1 -W 0.01 $ip 2>&1 1>/dev/null ; result="$?"
#   printf "\b\b\b\b\b\b\b\b\b\b\b\b"
#   #printf "\b%.0s" {1..$len}
#   
#   # notify user if we find a host.
#   if [ $result == 0 ]; then 
#     echo "host found on $ip"
#   fi
# done
