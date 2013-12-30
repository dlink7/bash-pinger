#!/bin/bash

declare -a arr=("a" "a" "b" "c" "b" "c")

declare -a cpy1=()

get_set_array()
{
	
	cpy1=("${arr[@]}")

for (( i=0; i<${#arr[@]} ; i++ ))
do

for (( j=i+1; j<${#arr[@]} ; j++ ))
do
	if [ "${arr[i]}" == "${arr[j]}" ]
	 then
	 unset cpy1[j]
		echo "${arr[i]} equal to  ${arr[j]}"
	fi
      
done

done


}

get_set_array

echo "print whole array: ${cpy1[@]}"
