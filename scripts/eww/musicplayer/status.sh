#!/bin/sh
isrunningqmmp=/tmp/eww/musicplayer/.qmmpmusicplayerrunning
isrunningspotify=/tmp/eww/musicplayer/.spotifymusicplayerrunning

if [ -e $isrunningspotify ]; then
      position=$(playerctl --player=spotify position 2>/dev/null)
      length=$(playerctl --player=spotify metadata mpris:length 2>/dev/null)
  
      # Fallback defaults
      if [ -z "$position" ] || [ -z "$length" ]; then
        echo "--:--/--:--"
        exit
      fi
  
      # Only proceed if both are non-empty
      if [ -n "$position" ] && [ -n "$length" ]; then
          position_sec=${position%.*}
          length_sec=$((length / 1000000))
      fi
  
      # Format and print
      printf "%d:%02d/%d:%02d\n" \
        $((position_sec / 60)) $((position_sec % 60)) \
        $((length_sec / 60)) $((length_sec % 60))
elif [ -e $isrunningqmmp ]; then
    qmmp --no-start --status | grep -o '[0-9]\+:[0-9]\+/[0-9]\+:[0-9]\+'
else
    echo "--:--/--:--"
fi
