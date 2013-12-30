#!/bin/bash


compare()
{
	# echo|awk -v n1=5.65 -v n2=3.14e-22  '{if (n1<n2) printf ("%s < %s\n", n1, n2); else printf ("%s >= %s\n", n1, n2);}'
	# avg = $1
	# echo "parameter 1 is $1"
	result=$(echo "$1<2.0" | bc);
	# result = `$1<2 | bc -l`
	# echo "result is $result"
	if [ $result -eq 1 ]
	 then
		echo "good time $1"
	else
		echo "time too long $1"
	fi

}



ping_results=$(ping -c 4 -q $1 | grep rtt 2>&1);

# echo $ping_results

# OIFS=$IFS
IFS='/'
i=0
for x in $ping_results
do
    i=`expr $i + 1`

	if [ $i -eq 5 ]
		then
		compare $x
		break
	fi    
done

if [ $i -eq 0 ] 
	    then	
		echo "Destination Host Unreachable"
	fi 