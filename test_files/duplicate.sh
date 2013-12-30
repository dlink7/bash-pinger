#!/bin/bash
list_1=( 'a' 'a' 'b' 'c' 'a' 'c' )
# list_1=( Jennifer Tonya Anna Sadie )


erased=""
erase()
{
	
		index=0
	 for l in "${list_1[@]}"
               do
               	echo "working with --> $l"
               	if [ "$l" == "$1" ]
               			then
               			unset list_1[$index]
               			
               			IFS=","
               			add=true
               			for e in $erased
               			do
               				echo "e ====> ($e) and l ====> ($l)"
               				if [ "$l" == "$e" ]; then
               					echo "e = l"
               					add=false
               					break
               				fi
               			done
               			if $add ; then
               				erased="$erased$l,"
               			fi
               			
               		fi
               	let index=index+1
               done

               echo "${list_1[@]}---"
               echo "$erased---"
}
# erase 'a'

declare -r TIME_LIMIT=700 #1 #sec
x=$1

echo "x is $x and TIME_LIMIT is $TIME_LIMIT"
	result=$(echo "$x<$TIME_LIMIT" | bc);
	echo "result is $result"
	if [ $result -eq 1 ]
	 then
	 echo "good time ($x)"

	else
		echo "long time ($x)"
	fi