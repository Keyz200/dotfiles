#!/bin/sh
isrunningqmmp=/tmp/eww/musicplayer/.qmmpmusicplayerrunning
isrunningspotify=/tmp/eww/musicplayer/.spotifymusicplayerrunning

if [ -e $isrunningspotify ]; then
    playerctl --player=spotify metadata --format "{{title}}" | cut -c1-40
elif [ -e $isrunningqmmp ]; then
    if [ -z "$(qmmp --pl-dump --no-start)" ]; then
        echo ""
    else
        song=$(qmmp --no-start  --nowplaying "%f" | sed -E 's|^[0-9]+ - ||; s|\[.*\]||g; s|\.mp3||; s|\.wav||; s|  +| |g; s/\|.*//g; s|&|\&|g; s/｜.*//g; s/.* - //' | cut -c1-40)
        echo "$song"
    fi
else
    echo ""
fi
    
