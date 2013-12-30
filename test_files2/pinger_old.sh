#!/bin/bash

declare -r TIME_LIMIT=3 #sec
declare -r CHECK_LIMIT=2 #5
declare -a list_1=() # list of ips with return code 1
declare -a list_2=() # list of ips with return code 2
declare -a repeated_list_1=() # list of ips with return code 1
declare -a repeated_list_2=() # list of ips with return code 2
declare -a list_set=()

log()
{
	txt=$1
	echo $txt
	echo  $txt>>"log/$(date +"%m-%d-%Y").log"
}

pingy()
{
	ip=$1
	# log "in pingy"
	log "$ip......."

ping_results=$(ping -c 10 -q $ip | grep rtt 2>&1)
IFS='/'
i=0
for x in $ping_results
do
    # i=`expr $i + 1`
    let i=i+1

	if [ $i -eq 5 ]
		then
		# log "time limit is: $TIME_LIMIT--"
		result=$(echo "$x<$TIME_LIMIT" | bc);
	if [ $result -eq 1 ]
	 then
	 log "good time ($x)"
	 return 0

	else
		log "long time ($x)"
		return 2
	fi

		
	fi    
done

if [ $i -eq 0 ] 
	    then	
	    log "no connection"
		return 1
	fi 
}

set_array_1()
{
s=$(echo "${list_1[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
list_set=()
IFS=' ' read -a list_set <<< "$s"
}
set_array_2()
{
s=$(echo "${list_2[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')
list_set=()
IFS=' ' read -a list_set <<< "$s"
}

count_1()
{
	e=$1
	c=0
	for a in "${list_1[@]}"
     do
     	
     	if [ "$e" == "$a" ]
     		then
     		# c=`expr $c + 1`
     		let c=c+1
     	fi
      
	done
	echo "$c"
}

count_2()
{
	e=$1
	c=0
	for a in "${list_2[@]}"
     do
     	
     	if [ "$e" == "$a" ]
     		then
     		# c=`expr $c + 1`
     		let c=c+1
     	fi
      
	done
	echo "$c"
}


set_repeated_values_1()
{
	set_array_1 
	repeated_list_1=()
	# log "EMPTY LIST EXPECTED: ${repeated_list_1[@]}---"
	for e in "${list_set[@]}"
     do
     	rpt=$(count_1 $e)
     	log "repeat: $rpt ($e)"
     	# log "repeat limit is: $CHECK_LIMIT--"

     	if [  "$rpt" -gt "$CHECK_LIMIT"  ]
     	 then
     		 repeated_list_1=("${repeated_list_1[@]}""$e" )

     		 # for r in "${repeated_list_1[@]}"
        #        do
     			 
     			#  # #remove r from list_1
     			#  # index=0
     			#  # for l in "${list_1[@]}"
        #  #       do

        #  #       	if [ "$l" == "$r" ]
        #  #       			then
        #  #       			unset list_1[$index]
        #  #       		fi
        #  #       	let index=index+1
        #  #       done
        #  #        #remove r from list_1 done
      
	       #    done

     	fi
	done
}

set_repeated_values_2()
{
	set_array_2
	repeated_list_2=()
	# log "EMPTY LIST EXPECTED: ${repeated_list_2[@]}---"
	for e in "${list_set[@]}"
     do
     	rpt=$(count_2 $e)
     	log "repeat: $rpt ($e)"
     	# log "repeat limit is: $CHECK_LIMIT--"
     	if [  "$rpt" -gt "$CHECK_LIMIT"  ] 
     		then
     		 repeated_list_2=("${repeated_list_2[@]}" "$e" )

     		 # for r in "${repeated_list_2[@]}"
        #        do
     			 
     			#  # #remove r from list_2
     			#  # index=0
     			#  # for l in "${list_2[@]}"
        #  #       do

        #  #       	if [ "$l" == "$r" ]
        #  #       			then
        #  #       			unset list_2[$index]
        #  #       		fi
        #  #       	let index=index+1
        #  #       done
        #  #        #remove r from list_2 done
      
	       #    done

     	fi
	done
}

erase_in_both()
{
		index=0
	 for l in "${list_1[@]}"
               do
               	if [ "$l" == "$1" ]
               			then
               			unset list_1[$index]
               		fi
               	let index=index+1
               done
       ###########################
	index=0
	 for l in "${list_2[@]}"
               do
               	if [ "$l" == "$1" ]
               			then
               			unset list_2[$index]
               		fi
               	let index=index+1
               done

}


# pingy "www.google.com"

c=0
while true
do
	let c=c+1
	log "start $c: ============================="
	log "[A] PINGING (X10) ========"

while read line
do
	h="#*"
	if [ "$line" != "$h" ]   
	   then
	pingy "$line"
     code=$?
	# echo "code = $code"	
	if [ "$code" -eq 0 ] 
		then
		erase_in_both "$line"
	fi
	if [ "$code" -eq 1 ] 
		then
		list_1=("${list_1[@]}" "$line" )
	fi

	if [ "$code" -eq 2 ] 
		then
	list_2=("${list_2[@]}" "$line" )
	fi

	fi
   
done < "ips.conf"

log "[B] CHECKING ======="

set_repeated_values_1
set_repeated_values_2

s=""
if [ ${#repeated_list_1[@]} -eq "$CHECK_LIMIT" ]
	then
s="$s \n no connection to : ${repeated_list_1[@]}"
fi

if [ ${#repeated_list_2[@]} -eq "$CHECK_LIMIT" ]
	then
s="$s \n long time to ips: : ${repeated_list_2[@]}"
fi

if [ ! -z "$s" ]
	then
	log "SMS: $s"
fi

	# log "sleeping..."
	sleep 1
done

