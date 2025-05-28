#!/bin/sh
quotetmp=/tmp/eww/dashboard/.quote
param=$1

while true; do
    if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
        break
    fi
    sleep 3
done

case $param in
	quote)	
		if [[ -e $quotetmp ]]; then
			rm -rf $quotetmp
		fi
		
		while true; do
		  quote=$(curl -s "https://meigen.doodlenote.net/api/json.php" | jq -r '.[0].meigen')
		  length=${#quote}
		  
		  if [ $length -le 43 ]; then
		    break
		  else
		    sleep 0.3
		  fi
		done
		echo "$quote" >> "$quotetmp"
	;;
	author)
		curl -s "https://meigen.doodlenote.net/api/json.php" | jq -r '.[1].meigen'
	;;
esac
