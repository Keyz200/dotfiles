#!/bin/sh
pinnedtmp=/tmp/eww/sysinfo/.pinned
unpinnedtmp=/tmp/eww/sysinfo/.unpinned
param=$1

case $param in 
	click)
		if [ -e $pinnedtmp ]; then
			eww -c $HOME/.config/eww_1/sysinfov2 close sysinfov2 &
			eww -c $HOME/.config/eww_1/sysinfov2 open hovertrigger &
			touch $unpinnedtmp
			rm -rf $pinnedtmp
		else
			touch $pinnedtmp
			rm -rf $unpinnedtmp
			notify-send "Sysinfo" "Pinned"
		fi
	;;
	hoverlost)
		if [[ ! -e $pinnedtmp ]]; then
			eww -c $HOME/.config/eww_1/sysinfov2 close sysinfov2 &
			eww -c $HOME/.config/eww_1/sysinfov2 open hovertrigger &
		fi
	;;
esac
