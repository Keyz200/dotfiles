#!/bin/sh
isrunningeww=/tmp/eww/musicplayer/.musicplayerrunning
isrunningqmmp=/tmp/eww/musicplayer/.qmmpmusicplayerrunning
isrunningspotify=/tmp/eww/musicplayer/.spotifymusicplayerrunning
playpausetmp=/tmp/eww/musicplayer/.playpause
param=$1

case $param in
	qmmp)
		if [ -e $isrunningspotify ]; then
			playerctl --player=spotify pause
			rm -rf $isrunningspotify
		fi
		
		if [ -e $isrunningqmmp ]; then
			qmmp --no-start -q & disown
		    rm -f $isrunningqmmp
		else
			qmmp --toggle-visibility -p & disown
			touch $isrunningqmmp
			if [ ! -e $isrunningeww ]; then
				screen=/tmp/eww/musicplayer/.musicplayerscreen
				if [ ! -e "${screen}0" ]; then
				    currentscreen="1"
				else
					currentscreen="0"
				fi
				eww -c ~/.config/eww_1/musicplayer/ open musicplayer --arg screen="$currentscreen"

				touch $isrunningeww
				$HOME/.config/scripts/eww/setrulesforeach.sh musicplayer
			fi
			sed -i "1s|.*||" "$playpausetmp"
		fi
	;;
	spotify)
		if [ -e $isrunningqmmp ]; then
			qmmp --no-start -q & disown
			rm -rf $isrunningqmmp
			playerctl --player=spotify play
		fi

		if [ -e $isrunningspotify ]; then
			playerctl --player=spotify play
			if [ ! -e $isrunningeww ]; then
				screen=/tmp/eww/musicplayer/.musicplayerscreen
				if [ ! -e "${screen}0" ]; then
				    currentscreen="1"
				else
					currentscreen="0"
				fi
				sed -i "1s|.*||" "$playpausetmp"
				eww -c ~/.config/eww_1/musicplayer/ open musicplayer --arg screen="$currentscreen"

				touch $isrunningeww
				$HOME/.config/scripts/eww/setrulesforeach.sh musicplayer
			fi
		else
			touch $isrunningspotify
			if [ ! -e $isrunningeww ]; then
				screen=/tmp/eww/musicplayer/.musicplayerscreen
				if [ ! -e "${screen}0" ]; then
				    currentscreen="1"
				else
					currentscreen="0"
				fi
				sed -i "1s|.*||" "$playpausetmp"
				eww -c ~/.config/eww_1/musicplayer/ open musicplayer --arg screen="$currentscreen"

				touch $isrunningeww
				$HOME/.config/scripts/eww/setrulesforeach.sh musicplayer
			fi
		fi
	;;
	hide)
		if [ -e $isrunningeww ]; then
		    eww -c ~/.config/eww_1/musicplayer/ close musicplayer
		    rm -f $isrunningeww
		    $HOME/.config/scripts/eww/setrulesforeach.sh musicplayer
		else
			screen=/tmp/eww/musicplayer/.musicplayerscreen
			if [ ! -e "${screen}0" ]; then
			    currentscreen="1"
			else
				currentscreen="0"
			fi
			eww -c ~/.config/eww_1/musicplayer/ open musicplayer --arg screen="$currentscreen"
			touch $isrunningeww
			$HOME/.config/scripts/eww/setrulesforeach.sh musicplayer
		fi
	;;
esac
