#!/bin/sh
param="$1"

case $param in
	usage)
		free -m | grep Mem | awk '{printf "%.1f/%.1f\n", $3/1000, $2/1000}'
	;;
	name)
		fastfetch | grep -i memory | awk '{printf "%s %s", $9, $10}' | sed -E "s|(.*)|(2x16) \\1|"
	;;
esac
