#!/bin/sh
param=$1

killnotification () {
	notifier="/tmp/eww/notifications/.notifier${param}"
	eww -c $HOME/.config/eww_1/notifications/ close notification$param
	rm -rf "$notifier"
}

case $param in
	1)
		killnotification
	;;
	2)
		killnotification
	;;
	3)
		killnotification
	;;
	4)
		killnotification
	;;
	5)
		killnotification
	;;
esac
