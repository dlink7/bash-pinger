#!/bin/bash

# create an array
xyz=(a b c d e)
echo ${xyz[@]}
orig_length=${#xyz[@]}

# remove an item
unset xyz[2]

echo ${xyz[@]}
echo

for (( i=0; i < orig_length; i++ )); do
	echo "$i: ${xyz[i]}"
done
