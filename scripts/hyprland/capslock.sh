#!/bin/sh
theme=$(tail -n 1 /home/keyz/.config/hypr/hyprland.conf | sed -E "s|.*([0-9]).*|\1|")

case "$theme" in
    4|5)
        "$HOME/.config/scripts/eww/bar/buttons.sh" menutoggle &
        ;;
    *)
    	ydotool mousemove -a -x 2360 -y440
        "$HOME/.config/scripts/eww/widgethandler.sh" dashboard &
        ;;
esac
