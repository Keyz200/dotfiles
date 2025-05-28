#!/bin/sh
hyprlandconf=/home/keyz/.config/hypr/hyprland.conf

currenttheme=$(tail -n 1 $hyprlandconf | sed -E "s|.*([0-9]).*|\1|")

pidof hyprlock || hyprlock -c "$HOME/.config/hypr/hyprlock${currenttheme}.conf"
