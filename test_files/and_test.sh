#!/bin/bash

erased=$1
problem=false
hasvalue=false

if [ ! -z "$erased" ]; then 
hasvalue=true
else
hasvalue=false
fi
 
if   $hasvalue  &&  $problem 
#if [ $another ] && [ $problem ]
#if  $another  &&  $problem 
	then
       echo "not empty problem=$problem hasvalue=$hasvalue = true"

      else
        echo "empty problem=$problem hasvalue=$hasvalue = false"
    fi

#echo "$problem"
echo "$(date +"%H:%M %d-%m-%Y")"

