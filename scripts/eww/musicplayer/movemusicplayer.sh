#!/bin/sh

#X_POS=1625
#Y_POS=549
YUCK_FILE=~/.config/eww/ewwmp/eww.yuck
current_monitor=$(grep ":monitor" "$YUCK_FILE" | grep -oP ":monitor\s+\K[0-9]+")
target_monitor="0"
EWWMP=/tmp/.ewwmprunning


# Replace placeholders or lines in the file
#sed -i "s/:monitor [0-9]*/:monitor $monitor/" "$YUCK_FILE"
#sed -i "s/:x [0-9]*/:x $X_POS/" "$YUCK_FILE"
#sed -i "s/:y [0-9]*/:y $Y_POS/" "$YUCK_FILE"

# Reload and open the window
#eww -c ~/.config/eww/ewwmp reload
#eww -c ~/.config/eww/ewwmp open music
if [ "$current_monitor" -ne "$target_monitor" ]; then
    sed -i "s/:monitor [0-9]*/:monitor 0/" "$YUCK_FILE"
    sleep 0.4
    eww -c ~/.config/eww/ewwmp/ update visible-state=true
    ~/.config/hypr/scripts/eww/setewwrules.sh ewwmp
    touch "$EWWMP"
else
	sed -i "s/:monitor [0-9]*/:monitor 1/" "$YUCK_FILE"
	sleep 0.4
	eww -c ~/.config/eww/ewwmp/ update visible-state=true
	~/.config/hypr/scripts/eww/setewwrules.sh ewwmp
	touch "$EWWMP"
fi
