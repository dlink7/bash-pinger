#!/bin/bash

declare -a arr=("a" "a" "b" "g" "b" "c")

count()
{
	e=$1
	# echo " iiiiii  $e"
	c=0
	for a in "${arr[@]}"
     do
     	
     	if [ "$e" == "$a" ]
     		then
     		# c=`expr $c + 1`
     		 let c=c+1
     	fi
      
	done
	echo "$c"
}

v=$(count $1) 

echo "count of a is $v"

# arr=("${arr[@]}" "$1" )
# echo "print whole array: ${arr[@]}"

