#!/bin/sh
param="$1"

case $param in
	musicplayer)
		ruleexist="/tmp/eww/musicplayer/.${param}rule"
		pid=$(pgrep -av aaaaa | grep -i "$param" | sed -n -E "s|([0-9]+).*eww -c .*|\1|p")
		address=$(hyprctl layers | grep -i "$pid" | awk '{printf "%s\n", $2}' | sed -E "s|(.*):|\1|")

		hyprctl keyword layerrule "blur,address:0x$address"
		if [ -e "$ruleexist" ]; then
			oldaddresses=$(cat $ruleexist)
			oldaddressesamount=$(echo "$oldaddresses" | wc -l)
			for i in $(seq 1 "$oldaddressesamount"); do
				removeaddress=$(echo "$oldaddresses" | head -n $i | tail -n 1)
			    hyprctl keyword layerrule "unset,address:0x$removeaddress"
			done
			rm -rf "$ruleexist"
		fi
		echo "$address" >> $ruleexist
	;;
	sysinfo)
		ruleexist="/tmp/eww/sysinfo/.${param}rule"
		pid=$(pgrep -av aaaaa | grep -i "$param" | sed -n -E "s|([0-9]+).*eww -c .*|\1|p")
		address=$(hyprctl layers | grep -i "$pid" | awk '{printf "%s\n", $2}' | sed -E "s|(.*):|\1|")
		addresses=$(echo "$address" | wc -l)

		for i in $(seq 1 "$addresses"); do
			addaddress=$(echo "$address" | head -n $i | tail -n 1)
		    hyprctl keyword layerrule "blur,address:0x$addaddress"
		done

		if [ -e "$ruleexist" ]; then
			oldaddresses=$(cat $ruleexist)
			oldaddressesamount=$(echo "$oldaddresses" | wc -l)
			for i in $(seq 1 "$oldaddressesamount"); do
				removeaddress=$(echo "$oldaddresses" | head -n $i | tail -n 1)
			    hyprctl keyword layerrule "unset,address:0x$removeaddress"
			done
			rm -rf "$ruleexist"
		fi
		echo "$address" >> $ruleexist
	;;
	dashboard)
		ruleexist="/tmp/eww/dashboard/.${param}rule"
		pid=$(pgrep -av aaaaa | grep -i "$param" | sed -n -E "s|([0-9]+).*eww -c .*|\1|p")
		address=$(hyprctl layers | grep -i "$pid" | awk '{printf "%s\n", $2}' | sed -E "s|(.*):|\1|")
		addresses=$(echo "$address" | wc -l)

		for i in $(seq 1 "$addresses"); do
			addaddress=$(echo "$address" | head -n $i | tail -n 1)
		    hyprctl keyword layerrule "blur,address:0x$addaddress"
		    hyprctl keyword layerrule "dimaround,address:0x$addaddress"
		done
		
		if [ -e "$ruleexist" ]; then
			oldaddresses=$(cat $ruleexist)
			oldaddressesamount=$(echo "$oldaddresses" | wc -l)
			for i in $(seq 1 "$oldaddressesamount"); do
				removeaddress=$(echo "$oldaddresses" | head -n $i | tail -n 1)
			    hyprctl keyword layerrule "unset,address:0x$removeaddress"
			done
			rm -rf "$ruleexist"
		fi
		echo "$address" >> $ruleexist
	;;		
esac
