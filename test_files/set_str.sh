#!/bin/bash

#declare -a arrname=("d" "ff")
#declare -a Unix=('Debian' 'Red hat' 'Red hat' 'Suse' 'Fedora')
#Uni=",a,d,c,a,b,b,b,a,c,d"
Uni=",s"
d="sdfasd"

IFS=','

set_set=""

for a in $Uni
do
echo $a
done

#echo "1"

#s=$(echo "${Uni[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

#echo "2"

#IFS=' ' read -a Uni <<< "$s"

#echo "${Uni[@]}"
