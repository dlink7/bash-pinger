#!/bin/bash

function p
{
ip=$1
ping_results=$(ping -c 2 -q $ip | grep rtt 2>&1)
echo $ping_results
}

p "localhost"
