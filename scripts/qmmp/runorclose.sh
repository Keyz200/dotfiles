#!/bin/sh
#LOCKFILE="/tmp/musicplayer.lock"
#COOLDOWN=1

# Open file descriptor 200 for LOCKFILE
#exec 200>"$LOCKFILE"

# Try to acquire lock, exit if not possible
#if ! flock -n 200; then
#    echo "Already running. Exiting." >&2
#    exit 1
#fi

# === Your actual logic ===


# Hold lock for cooldown duration
#sleep "$COOLDOWN"
#rm -f /tmp/musicplayer.lock


QMMP=/tmp/.qmmprunning
EWWMP=/tmp/.ewwmprunning

if [ ! -e $QMMP ]; then
	eww -c ~/.config/eww/ewwmp/ update visible-state=true
	qmmp --toggle-visibility -p
	touch $QMMP
	touch $EWWMP
else
	eww -c ~/.config/eww/ewwmp/ update visible-state=false
	qmmp --no-start -q
	rm -f $QMMP
	rm -f $EWWMP
fi
