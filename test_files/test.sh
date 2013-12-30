#!/bin/bash

#declare -a Unix=()

declare -a Unix=('Debian' 'Red hat' 'Red hat' 'Suse' 'Fedora');

while true
do

echo -e "\n\nreading from file..............."

while read line
do
          h="#*"
	if [[ "$line" != "$h" ]];then
          echo "not ww: $line---"
	fi

done < "ips.conf"

echo -e "\narray........................"
Unix=("${Unix[@]}" "leul" )
echo "print whole array: ${Unix[@]}"
echo "array size: ${#Unix[@]}"
echo "Extraction: ${Unix[@]:3:2}"
unset Unix[3]
echo "THIS IS STUFF FOR THE FILE" >>"output.log"

NOW=$(date +"%d-%m-%Y")
echo "date is $NOW"
echo "Press [CTRL+C] to stop.."
sleep 1
done
