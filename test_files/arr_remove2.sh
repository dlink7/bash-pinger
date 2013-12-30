#!/bin/bash

HOSTNAMES=(a b c d e f c)
HOSTNAME=c

echo "before: ${HOSTNAMES[@]}"
HOSTNAMES=($(for h in ${HOSTNAMES[@]}; do [ "$h" != "$HOSTNAME" ] && echo $h; done ))
echo "after: ${HOSTNAMES[@]}"
echo "${#HOSTNAMES[@]}"

#for host in "${HOSTNAMES[@]}"; do
#	ping "$host" 1 &> /dev/null && echo "${host}... ok"
#done
