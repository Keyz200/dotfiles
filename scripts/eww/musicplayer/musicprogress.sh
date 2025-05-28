#!/bin/sh
isrunningqmmp=/tmp/eww/musicplayer/.qmmpmusicplayerrunning
isrunningspotify=/tmp/eww/musicplayer/.spotifymusicplayerrunning
param=$1

case $param in
    length)
        if [ -e $isrunningspotify ]; then
            # Get total length from Spotify in microseconds and convert to seconds
            length=$(playerctl --player=spotify metadata mpris:length 2>/dev/null)
            if [ -n "$length" ]; then
                length_sec=$((length / 1000000))
                echo "$length_sec"
            else
                echo "--:--/--:--"
            fi
        elif [ -e $isrunningqmmp ]; then
            musiclength=$(qmmp --no-start --status | grep -o '[0-9]\+:[0-9]\+/[0-9]\+:[0-9]\+' | sed -E 's|([0-9]+):([0-9]+)/([0-9]+):([0-9]+)|\1 \2 \3 \4|' | awk '{current = ($1 * 60) + $2; total = ($3 * 60) + $4; printf "%.0f\n", total}')
            echo "$musiclength"
        else
            echo "--:--/--:--"
        fi
    ;;
    
    progress)
        if [ -e $isrunningspotify ]; then
            # Get current position from Spotify in seconds
            position=$(playerctl --player=spotify position 2>/dev/null)
            if [ -n "$position" ]; then
                position_sec=${position%.*}
                echo "$position_sec"
            else
                echo "--:--/--:--"
            fi
        elif [ -e $isrunningqmmp ]; then
            musicprogress=$(qmmp --no-start --status | grep -o '[0-9]\+:[0-9]\+/[0-9]\+:[0-9]\+' | sed -E 's|([0-9]+):([0-9]+)/([0-9]+):([0-9]+)|\1 \2 \3 \4|' | awk '{current = ($1 * 60) + $2; printf "%.0f\n", current}')
            echo "$musicprogress"
        else
            echo "--:--/--:--"
        fi
    ;;
esac


