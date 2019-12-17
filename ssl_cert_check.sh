#!/bin/bash

function displaytime {
  local T=$1
  local D=$((T/60/60/24))
  local H=$((T/60/60%24))
  local M=$((T/60%60))
  local S=$((T%60))
  (( $D > 0 )) && printf '%d days ' $D
  (( $H > 0 )) && printf '%d haours ' $H
  (( $M > 0 )) && printf '%d minutes ' $M
  (( $D > 0 || $H > 0 || $M > 0 )) && printf 'and '
  printf '%d seconds\n' $S
}


date=$(openssl x509 -noout -dates -in $1 | grep After)
date=${date/notAfter=/}
date2=$(date --date="$date" --utc +"%d-%m-%Y %H:%M")
#echo "cert: "$date2
date=$(date --date="$date" --utc +"%s")
#echo "cert: "$date
dzis=$(date --utc +"%d-%m-%Y %H:%M")
#echo "dzis: "$dzis
dzis=$(date --utc +"%s")
#echo "dzis: "$dzis
diff=$((date-dzis))
#echo "diff:  "$diff

info=$(displaytime $diff)
#echo $info

#60*60*24*7 = 7 days
if (($diff>1  &&  $diff<60*60*24*7)); then 
	echo "WARNING - ending in $info ($date2)"
	exit 1

elif (( "$diff" > 0 )); then
        echo "OK - ending in $info ($date2)"
        exit 0
else
	echo "CRITICAL - ended $date"
	exit 2
fi
