#!/bin/sh
param=$1
param2=$2
timevisible="8"

killnotification () {
	notifier="/tmp/eww/notifications/.notifier${param}"
	
	while true; do
		read -r started < "$notifier"

		if ! [[ "$started" =~ ^[0-9]+$ ]]; then
			echo "Invalid timestamp: $started"
			exit 1
		fi
		currenttime=$(date +%s)
		elapsed=$((currenttime - started))
		if [ "$elapsed" -ge $timevisible ]; then
			if [[ "$param2" == "on" ]]; then
				eww -c ~/.config/eww_1/notifications/ open notifrev$param && eww -c ~/.config/eww_1/notifications/ update animate${param}=false
			else
				eww -c $HOME/.config/eww_1/notifications/ close notification$param
			fi
			rm -rf "$notifier"
			break
		fi
		sleep 1
	done
}


case $param in
	1)
		killnotification
	;;
	2)
		killnotification
	;;
	3)
		killnotification
	;;
	4)
		killnotification
	;;
	5)
		killnotification
	;;
esac
