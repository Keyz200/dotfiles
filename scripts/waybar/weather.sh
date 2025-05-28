#!/bin/sh
while true; do
    if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
        break
    fi
    sleep 3
done

param=$1

case $param in
	temperature)
		WEATHER=$(curl -s "wttr.in/Texas?format=1" | sed -E 's/[^0-9-]*([0-9]+°[CF])/\1/'
		)
		if [[ "$WEATHER" == *"Unknown"* ]]; then
			echo "1°C"
		else
			echo "$WEATHER"
		fi
	;;
	forecast)
		WEATHER=$(curl -s "wttr.in/Texas?2&m" | sed -E "s/(Location:.*|Follow.*)//" | sed -E "s/Weather.*/Your city weather:/")
		echo "$WEATHER"
		read -rsp $'Press escape to close...\n' -d $'\e'
	;;
esac
