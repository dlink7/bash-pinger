#!/bin/bash

declare -r TIME_LIMIT=2 #sec
declare -r CHECK_LIMIT=4
declare -r PING_TIMES=10

declare -a list_1=() # count of ips with return code 1
declare -a list_2=() # count of ips with return code 2
declare -a ips=()
#LOG_PATH="log/"
#LOG_PATH="/home/better/bash/log/"
LOG_PATH="/home/luke/pinger/log/"
phone_number1="+251910541927"
phone_number2="+251912502582"
phone_number3="+251910614464"

sms_fixed=""
sms_problem=""

log()
{
  txt="$1 $(date +" (%H:%M) %d-%m-%Y")"
	# echo $txt
	echo  $txt>>"$LOG_PATH$(date +"%d-%m-%Y").log"
}

pingy()
{
	ip=$1
	# log "in pingy"
	log "$ip......."

ping_results=$(ping -c $PING_TIMES -q $ip | grep rtt 2>&1)
IFS='/'
i=0
for x in $ping_results
do
    # i=`expr $i + 1`
    let i=i+1

	if [ $i -eq 5 ]
		then

    # log "*********($x)***********************($TIME_LIMIT)********"
		result=$(echo "$x<$TIME_LIMIT" | bc);
	if [ $result -eq 1 ]
    # log "result is $result"
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

sms()
{
	sms="$1 $(date +" (%H:%M) %d-%m-%Y")"
        sms_single "$sms" "$phone_number1"
        # sms_single "$sms" "$phone_number2"
        # sms_single "$sms" "$phone_number3"
    }

sms_single()
{
txt=$1
phone_number=$2
curl -v http://localhost:13013/cgi-bin/sendsms\?username=simple\&password=elpmis\&to=$phone_number\&text=$( rawurlencode "$txt" )
}

check_fixed()
{
i=$1

#log "I = ($i) CODE IS ZERO ON (${ips[$i]}) LIST_1[$i] = (${list_1[$i]}) LIST_2[$i] = (${list_2[$i]}) CHECK_LIMIT = ($CHECK_LIMIT)"

if [ "${list_1[$i]}" -gt "$CHECK_LIMIT" -o "${list_1[$i]}" -eq "$CHECK_LIMIT" ]; then
#log "LIST_1[$i] >= CHECK_LIMIT --- ADDED TO FIXED: ${ips[$i]}"
sms_fixed="$sms_fixed [FIXED: no connection at ${ips[$i]}]"
list_1[$i]=0
fi


if [ "${list_2[$i]}" -gt "$CHECK_LIMIT" -o "${list_2[$i]}" -eq "$CHECK_LIMIT" ]; then
#log "LIST_2[$i] >= CHECK_LIMIT --- ADDED TO FIXED: ${ips[$i]}"
sms_fixed="$sms_fixed [FIXED: long time at ${ips[$i]}]"
list_2[$i]=0
fi

}

check_list_1()
{
i=$1
let list_1[$i]=list_1[$i]+1
#log "I = ($i) NO CONNECTION ON (${ips[$i]}) LIST_1[$i] = (${list_1[$i]})"
if [ "${list_1[$i]}" -eq "$CHECK_LIMIT" ] ; then
#log "LIST_1[$i] == ${list_1[$i]} == $CHECK_LIMIT"
sms_problem="$sms_problem [No connection on ${ips[$i]}]"
fi
}

check_list_2()
{
i=$1
let list_2[$i]=list_2[$i]+1
#log "I = ($i) LONG TIME ON (${ips[$i]}) LIST_2[$i] = (${list_2[$i]})"
if [ "${list_2[$i]}" -eq "$CHECK_LIMIT" ] ; then
#log "LIST_2[$i] == ${list_2[$i]} == $CHECK_LIMIT"
sms_problem="$sms_problem [Long time  on ${ips[$i]}]"
fi
}


rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER)
}

init()
{
while read line
do
ips=("${ips[@]}" "$line")
list_1=("${list_1[@]}" 0)
list_2=("${list_2[@]}" 0)
done < "ips.conf"
}

init

counter=0
while true
do
	let counter=counter+1
	log $'\n'"start $counter: ============================="
	log "PINGING (X10) ========="

    ii=0
for ip in "${ips[@]}" 
do
	pingy "$ip"
        code=$?
	###########	
	if [ "$code" -eq 0 ] ; then
         check_fixed "$ii"
        fi
	if [ "$code" -eq 1 ] ; then
        check_list_1 "$ii"	
        fi

	if [ "$code" -eq 2 ] ; then
        check_list_2 "$ii"
	fi

    let ii=ii+1
    done

if [ ! -z "$sms_problem" ] ; then
sms "$sms_problem"
log "SMS PROBLEM: $sms_problem"
sms_problem=""
fi


if [ ! -z "$sms_fixed" ] ; then
sms "$sms_fixed"
log "SMS FIXED: $sms_fixed"
sms_fixed=""
fi

sleep 1

done
