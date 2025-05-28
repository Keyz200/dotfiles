#!/bin/sh
isrunningqmmp=/tmp/eww/musicplayer/.qmmpmusicplayerrunning
isrunningspotify=/tmp/eww/musicplayer/.spotifymusicplayerrunning

if [ -e $isrunningspotify ]; then
    song=$(playerctl --player=spotify metadata --format '{{ artist }} - {{ title }}')
    echo "$song"
elif [ -e $isrunningqmmp ]; then
    song=$(qmmp --no-start  --nowplaying "%f" | sed -E 's|^[0-9]+ - ||; s|\[.*\]||g; s|\.mp3||; s|\.wav||; s|  +| |g; s/\|.*//g; s|&|\&|g; s/｜.*//g; s|\(Official.*||g')
    echo "$song"
else
    echo "No song playing"
fi
