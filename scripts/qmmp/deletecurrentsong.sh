#!/bin/sh

# Get the currently playing info from QMMP
file_name=$(qmmp --nowplaying "%f")
full_path=$(qmmp --nowplaying "%F")

# Search for the file directly by name
if [ -n "$file_name" ] && [ "$file_name" != "(none)" ]; then
    # Check if the file exists
    if [ -f "$full_path" ]; then
        # Ask QMMP to play the next track
        qmmp --next
        
        # Small delay to ensure QMMP has moved to the next track
        sleep 0.5
        
        # Permanently delete the file (bypass trash)
        rm -f "$full_path"
        
        # Show notification
        notify-send "Deleted" "$file_name"
    else
        echo "File not found: $full_path"
        notify-send "Failed to delete" "$file_name (file not found)"
    fi
else
    echo "No song playing"
    notify-send "No song playing" "qmmp"
fi
