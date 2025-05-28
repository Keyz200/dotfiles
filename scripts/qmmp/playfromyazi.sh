#!/bin/sh
isrunningeww=/tmp/eww/musicplayer/.musicplayerrunning
isrunningqmmp=/tmp/eww/musicplayer/.qmmpmusicplayerrunning
playpausetmp=/tmp/eww/musicplayer/.playpause

if [ ! -e $isrunningqmmp ]; then
	touch $isrunningqmmp
	ydotool type cc
	qmmp --toggle-visibility -p "$(wl-paste)" & disown
	screen=/tmp/eww/musicplayer/.musicplayerscreen
	if [ ! -e "${screen}0" ]; then
	    currentscreen="1"
	else
		currentscreen="0"
	fi
	sed -i "1s|.*||" "$playpausetmp"
	eww -c ~/.config/eww_1/musicplayer/ open musicplayer --arg screen="$currentscreen"

	touch $isrunningqmmp $isrunningeww
	$HOME/.config/scripts/eww/setrulesforeach.sh musicplayer
else
	ydotool type cc
	qmmp --no-start --pl-clear 
	qmmp "$(wl-paste)"
fi
