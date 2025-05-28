#!/bin/sh
volumeicontmp=/tmp/eww/bar/.volumeicon
micicontmp=/tmp/eww/bar/.micicon
neticontmp=/tmp/eww/bar/.neticon

while true; do
	currentvolume=$(pamixer --get-volume)
	if [[ "$currentvolume" -gt "0" ]]; then
		sed -i "1s|.*||" "$volumeicontmp"
	else
		echo "$currentvolume so "
		sed -i "1s|.*||" "$volumeicontmp"
	fi

	currentvolumesource=$(pamixer --default-source --get-volume)
	if [[ "$currentvolumesource" -gt "0" ]]; then
		sed -i "1s|.*||" "$micicontmp"
	else
		sed -i "1s|.*||" "$micicontmp"
	fi

	if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
		sed -i "1s|.*|󰒢|" "$neticontmp"
	else
		sed -i "1s|.*|󰞃|" "$neticontmp"
	fi
	sleep 2
done
