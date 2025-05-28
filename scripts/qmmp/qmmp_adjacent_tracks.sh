#!/bin/sh

# Get the full playlist
playlist=$(qmmp --no-start --pl-dump)

# Get the current playing file
current=$(qmmp --no-start --nowplaying "%f")

# First try to find a line marked with [*]
current_line=""
while IFS= read -r line; do
    if [[ "$line" == *"[*]"* ]]; then
        # Found line with [*]
        current_line="$line"
        break
    fi
done <<< "$playlist"

# Get the line number of the current song
current_index=0
if [ -n "$current_line" ]; then
    # Extract number at beginning of line
    current_index=$(echo "$current_line" | grep -o '^[0-9]*\.')
    current_index=${current_index%?}  # Remove trailing dot
    echo "DEBUG: Found current song with [*]: $current_line (index: $current_index)" >> /tmp/qmmp_debug.log
else
    echo "DEBUG: No [*] marker found, trying by name: $current" >> /tmp/qmmp_debug.log
    # No [*] found, try to match by filename
    current_index=0
    line_number=0
    while IFS= read -r line; do
        line_number=$((line_number + 1))
        if [[ "$line" == *"$current"* ]]; then
            current_index=$line_number
            current_line="$line"
            echo "DEBUG: Found by name match at line $current_index: $line" >> /tmp/qmmp_debug.log
            break
        fi
    done <<< "$playlist"
fi

# If we still don't have a current line, try to parse playlist differently
if [ -z "$current_line" ] || [ "$current_index" -eq 0 ]; then
    # Convert playlist to array
    mapfile -t playlist_array <<< "$playlist"
    total_tracks=${#playlist_array[@]}
    
    # Look for any line with [*]
    for ((i=0; i<total_tracks; i++)); do
        if [[ "${playlist_array[$i]}" == *"[*]"* ]]; then
            current_index=$((i + 1))
            current_line="${playlist_array[$i]}"
            echo "DEBUG: Found by array method at index $current_index: $current_line" >> /tmp/qmmp_debug.log
            break
        fi
    done
fi

# Get total number of tracks
total_tracks=$(echo "$playlist" | wc -l)
total_tracks=$(echo "$total_tracks" | tr -d '[:space:]')

# Calculate the previous and next indices
prev_index=$((current_index - 1))
next_index=$((current_index + 1))

# Extract the songs
prev_song=""
current_song=""
next_song=""

# Handle edge cases
if [ "$prev_index" -lt 1 ] || [ "$current_index" -eq 0 ]; then
    prev_song=""
else
    prev_line=$(echo "$playlist" | sed -n "${prev_index}p")
    prev_song=$(echo "$prev_line" | sed 's/^[0-9]*\. //' | sed -E 's/^[0-9]+ - //; s/\[.*\]//g; s/\(.*//; s/\|.*//; s/\.(mp3|wav)$//; s/  +/ /g; s/^ +| +$//g')
fi

if [ "$current_index" -eq 0 ]; then
    current_song="Unknown current song"
else
    current_song=$(echo "$current_line" | sed 's/^[0-9]*\. //' | sed 's/ \[*\]//')
fi

if [ "$next_index" -gt "$total_tracks" ] || [ "$current_index" -eq 0 ]; then
    next_song=""
else
    next_line=$(echo "$playlist" | sed -n "${next_index}p")
    next_song=$(echo "$next_line" | sed 's/^[0-9]*\. //' | sed -E 's/^[0-9]+ - //; s/\[.*\]//g; s/\(.*//; s/\|.*//; s/\.(mp3|wav)$//; s/  +/ /g; s/^ +| +$//g')
fi

# Output based on the requested type
case "$1" in
    "prev")
        echo "$prev_song"
        ;;
    "next")
        echo "$next_song"
        ;;
    *)
        echo "Previous: $prev_song"
        echo "Current: $current_song"
        echo "Next: $next_song"
        ;;
esac
