#!/bin/sh

sleep 1
ydotool key 29:1 46:1 46:0 29:0
sleep 0.1
mpv "$(wl-paste)"
