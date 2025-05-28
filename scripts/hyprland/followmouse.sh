#!/bin/sh
follow_mouse=$(hyprctl getoption input:follow_mouse | head -n 1 | sed -E "s|int: (.*)|\1|")
if [[ $follow_mouse == 1 ]]; then
	hyprctl keyword input:follow_mouse 2
else
	hyprctl keyword input:follow_mouse 1
fi
