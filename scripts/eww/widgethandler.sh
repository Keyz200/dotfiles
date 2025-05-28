#!/bin/sh
param=$1

case $param in
	dashboard)
		#hyprctl dispatch togglespecialworkspace darken
		isrunning=/tmp/eww/dashboard/.dashboard
		dashboardwidgets=(folders hardwareinfo switch fullhardwareinfo apps timer host musicplayer quote weather daytime todo colorpicker nightlight lock power)
		if [[ -e $isrunning ]]; then
			# eww -c $HOME/.config/eww_1/dashboard/ update isvisible=false
			eww -c $HOME/.config/eww_1/dashboard/ close-all --restart
			$HOME/.config/scripts/eww/setrulesforeach.sh dashboard
			rm -rf $isrunning
		else
			# eww -c $HOME/.config/eww_1/dashboard/ update isvisible=true
			eww -c $HOME/.config/eww_1/dashboard/ open background
			eww -c $HOME/.config/eww_1/dashboard/ open user
			$HOME/.config/scripts/eww/setrulesforeach.sh dashboard
			for widget in "${dashboardwidgets[@]}"; do
				eww -c $HOME/.config/eww_1/dashboard/ open "$widget"
			done
			# eww -c $HOME/.config/eww_1/dashboard/ open-many folders hardwareinfo switch fullhardwareinfo apps timer host musicplayer quote weather daytime todo colorpicker nightlight lock power
			touch $isrunning
		fi
	;;
	sysinfo)
		isrunning=/tmp/eww/sysinfo/.sysinforunning
		screen=/tmp/eww/sysinfo/.sysinfoscreen
		if [ -e $isrunning ]; then
		    eww -c $HOME/.config/eww_1/sysinfo/ close-all
		    rm -f $isrunning
		    #$HOME/.config/scripts/eww/setrulesforeach.sh sysinfo
		else
			if [[ ! -e "${screen}0" ]]; then
				currentscreen="1"
				if hyprctl activewindow -j | jq -e 'select(.fullscreen == "1")' > /dev/null; then
					posy="-29"
					bgposy="-36"
				else
					posy="18"
					bgposy="11"
				fi
			else
				currentscreen="0"
				posy="18"
				bgposy="11"
			fi
		    #eww -c $HOME/.config/eww_1/sysinfo/ open background --arg screen="$currentscreen" --arg posy="$bgposy"
   			eww -c $HOME/.config/eww_1/sysinfo/ open-many disks memory cpu gpu --arg screen="$currentscreen" --arg posy="$posy"
		    #$HOME/.config/scripts/eww/setrulesforeach.sh sysinfo
			touch $isrunning
		fi
	;;
	movesysinfo)
		isrunning=/tmp/eww/sysinfo/.sysinforunning
		screen=/tmp/eww/sysinfo/.sysinfoscreen
		if [ ! -e "${screen}0" ]; then
			posy="18"
			bgposy="11"
		    #eww -c $HOME/.config/eww_1/sysinfo/ open background --arg screen=0 --arg posy="$bgposy"
   			eww -c $HOME/.config/eww_1/sysinfo/ open-many disks memory cpu gpu --arg screen=0 --arg posy="$posy"
		    touch "${screen}0"
		    rm -rf "${screen}1"
		else
			if hyprctl activewindow -j | jq -e 'select(.fullscreen == "1")' > /dev/null; then
				posy="-29"
				bgposy="-36"
			else
				posy="18"
				bgposy="11"
			fi
			#eww -c $HOME/.config/eww_1/sysinfo/ open background --arg screen=1 --arg posy="$bgposy"
			eww -c $HOME/.config/eww_1/sysinfo/ open-many disks memory cpu gpu --arg screen=1 --arg posy="$posy"
			touch "${screen}1"
			rm -rf "${screen}0"
		fi
		#$HOME/.config/scripts/eww/setrulesforeach.sh sysinfo sysinfo
		touch $isrunning
	;;
	movemusicplayer)
		isrunning=/tmp/eww/musicplayer/.musicplayerrunning
		screen=/tmp/eww/musicplayer/.musicplayerscreen
		if [ ! -e "${screen}0" ]; then
		    eww -c ~/.config/eww_1/musicplayer/ open musicplayer --arg screen=0
		    touch "${screen}0" "$isrunning"
		    rm -rf "${screen}1"
		else
			eww -c ~/.config/eww_1/musicplayer/ open musicplayer --arg screen=1
			touch "${screen}1" "$isrunning"
			rm -rf "${screen}0"
		fi
		$HOME/.config/scripts/eww/setrulesforeach.sh musicplayer
		
	;;
	
esac
