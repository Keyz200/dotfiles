#!/bin/sh
isrunningqmmp=/tmp/eww/musicplayer/.qmmpmusicplayerrunning
isrunningspotify=/tmp/eww/musicplayer/.spotifymusicplayerrunning

if [ -e $isrunningspotify ]; then
    echo ""
elif [ -e $isrunningqmmp ]; then
    qmmp --no-start -s && qmmp --pl-clear --no-start && qmmp --no-start --add-dir -p &
    sleep 0.4
    ydotool key 42:1 15:1 15:0 42:0
fi
