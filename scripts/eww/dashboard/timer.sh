#!/bin/sh
timerstartedtmp=/tmp/eww/dashboard/.timerstarted
timerpausedtmp=/tmp/eww/dashboard/.timerpaused

if [ -e "$timerpausedtmp" ]; then
	pausedtime=$(cat $timerpausedtmp)
	startedtime=$(cat $timerstartedtmp)
	elapsed=$((pausedtime - startedtime))
	printf "%02d:%02d\n" $((elapsed / 60)) $((elapsed % 60))
elif [ -e "$timerstartedtmp" ]; then
	starttime=$(cat $timerstartedtmp)
	currenttime=$(date +%s)
	elapsed=$((currenttime - starttime))
	printf "%02d:%02d\n" $((elapsed / 60)) $((elapsed % 60))
else
	echo "00:00"
fi
	
