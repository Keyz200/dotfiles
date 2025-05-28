#!/bin/sh
isrunningqmmp=/tmp/eww/musicplayer/.qmmpmusicplayerrunning
isrunningspotify=/tmp/eww/musicplayer/.spotifymusicplayerrunning
playpausetmp=/tmp/eww/musicplayer/.playpause

param=$1

case $param in
	playpause)
		if [ -e $isrunningspotify ]; then
			isplaying=$(playerctl --player=spotify status)
			if [[ "$isplaying" == "Playing" ]]; then
				sed -i "1s|.*||" "$playpausetmp"
				playerctl --player=spotify pause
			else
				sed -i "1s|.*||" "$playpausetmp"
				playerctl --player=spotify play
			fi
		elif [ -e $isrunningqmmp ]; then
			isplaying=$(qmmp --no-start --status | head -n 1 | sed -E "s|\[(.*)\].*|\1|")
			if [[ "$isplaying" == "playing" ]]; then
				sed -i "1s|.*||" "$playpausetmp"
				qmmp --no-start -u
			else
				sed -i "1s|.*||" "$playpausetmp"
				qmmp --no-start -p
			fi
		fi
	;;
	next)
		sed -i "1s|.*||" "$playpausetmp"
		if [ -e $isrunningspotify ]; then
			playerctl --player=spotify next
		elif [ -e $isrunningqmmp ]; then
			qmmp --no-start --next
		fi
	;;
	previous)
		sed -i "1s|.*||" "$playpausetmp"
		if [ -e $isrunningspotify ]; then
			playerctl --player=spotify previous
		elif [ -e $isrunningqmmp ]; then
			qmmp --no-start --previous
		fi
	;;
	shuffle)
		if [ -e $isrunningspotify ]; then
			status=$(playerctl --player=spotify shuffle)
			if [[ "$status" == "Off" ]]; then
				playerctl --player=spotify shuffle on
				notify-send "Spotify" "Shuffle On"
			else
				playerctl --player=spotify shuffle off
				notify-send "Spotify" "Shuffle off"
			fi
		elif [ -e $isrunningqmmp ]; then
			status=$(qmmp --pl-state | head -n 1 | sed -E 's|.*\[(.*)\]|\1|')
			if [[ "$status" == "-" ]]; then
				qmmp --no-start --pl-shuffle-toggle
				notify-send "QMMP" "Shuffle on"
			else
				qmmp --no-start --pl-shuffle-toggle
				notify-send "QMMP" "Shuffle off"
			fi
		fi
	;;
	# seekfwd)
	# 	if [ -e $isrunningspotify ]; then
	# 		playerctl --player=spotify position 5+
	# 	elif [ -e $isrunningqmmp ]; then
	# 		qmmp --no-start --seek-fwd 5
	# 	fi
	# ;;
	# seekbwd)
	# 	if [ -e $isrunningspotify ]; then
	# 		playerctl --player=spotify position 5-
	# 	elif [ -e $isrunningqmmp ]; then
	# 		qmmp --no-start --seek-bwd 5
	# 	fi
	# ;;
esac
	
