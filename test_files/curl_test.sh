#!/bin/bash
#CT="Content-Type:application/json"

phone_number="+251910614464"
sms="testing_sms_with_no_space"
TEST="curl -v http://localhost:13013/cgi-bin/sendsms\?username=simple\&password=elpmis\&to=$phone_number\&text=$sms"

#TEST="curl www.google.com"
RESPONSE=`$TEST`
echo $RESPONSE

##################################################################################################################
#CT="Content-Type:application/json"

phone_number="+251910614464"
sms="testing sms with no space\n abebe\n beso"

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



curl -v http://localhost:13013/cgi-bin/sendsms\?username=simple\&password=elpmis\&to=$phone_number\&text=$( rawurlencode "$sms" )

#RESPONSE=`$TEST`
#echo $RESPONSE

