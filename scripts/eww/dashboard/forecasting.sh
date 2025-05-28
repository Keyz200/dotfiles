#!/bin/sh
param=$1
while true; do
    if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
        break
    fi
    sleep 3
done

weathertmp=/tmp/eww/dashboard/.weather
weatherinfo=$(curl -s 'wttr.in/Texas?format=j1' | jq -r '
                   .weather[0,1] |
                   {
                     date: .date | strptime("%Y-%m-%d") | strftime("%a %d %b"),
                     morning: (.hourly[1]),  # Index 2 is 0300
                     noon:    (.hourly[3]),  # Index 4 is 0900
                     evening: (.hourly[5]),  # Index 6 is 1500
                     night:   (.hourly[7])   # Index 7 is 2100
                   } |
                   "\(.date)\nmorning = \(.morning.tempC)°C \(.morning.weatherDesc[0].value)\nnoon = \(.noon.tempC)°C \(.noon.weatherDesc[0].value)\nevening = \(.evening.tempC)°C \(.evening.weatherDesc[0].value)\nnight = \(.night.tempC)°C \(.night.weatherDesc[0].value)\n"
                 ')

if [[ "$weatherinfo" == *"Unknown"* ]]; then
	exit 1
fi

outputinfo () {
	temp=$(echo "$weatherinfo" | head -n $1 | tail -n 1 | awk '{printf "%s", $3}')
	weather=$(echo "$weatherinfo" | head -n $1 | tail -n 1 | awk '{printf "%s %s %s", $4, $5, $6}')
	if [[ "$2" == *"daytime"* ]]; then
		if [[ "$weather" == *"Partly Cloudy"* ]]; then
			echo " $temp"
		elif [[ "$weather" == "Cloudy" ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Sunny"* ]]; then
			echo "󰖨 $temp"
		elif [[ "$weather" == *"Clear"* ]]; then
			echo "󰖨 $temp"
		elif [[ "$weather" == *"Patchy rain"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"rain"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"drizzle"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"snow"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Mist"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Fog"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Haze"* ]]; then
			echo " $temp"
		else 
			echo "$temp"
		fi
	else
		if [[ "$weather" == *"Partly Cloudy"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Cloudy"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Sunny"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Clear"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Patchy rain"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"rain"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"drizzle"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"snow"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Mist"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Fog"* ]]; then
			echo " $temp"
		elif [[ "$weather" == *"Haze"* ]]; then
			echo " $temp"
		else 
			echo "$temp"
		fi
	fi
}
rm -rf "$weathertmp"
i=2
while [ "$i" -lt 12 ]; do
    if [ "$i" -eq 6 ]; then
         i=$((i + 2))
     fi

    if [ "$i" -ne 5 ] && [ "$i" -ne 11 ] && [ "$i" -ne 2 ] && [ "$i" -ne 8 ]; then
        arg2="daytime"
    else
        arg2="nighttime"
    fi

    get=$(outputinfo "$i" "$arg2")
    echo "$get" >> "$weathertmp"
	echo "$i"
    i=$((i + 1))
done

echo "$weatherinfo" | awk '{printf "%s\n", $4}' | sed 's|Patchy||' | sed 's|nearby||' >> $weathertmp 







