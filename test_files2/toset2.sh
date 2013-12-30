#!/bin/bash

declare -a arr=("a" "a" "b" "c" "b" "c")



set_array()
{

s=$(echo "${arr[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
#arr=()
IFS=' ' read -a arr <<< "$s"

#IFS=$'\n'  sort -u <<< "${arr[*]}"
}

set_array
echo "print whole array: ${arr[@]}"
