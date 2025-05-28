#!/bin/sh
dashboardtmp=/tmp/eww/dashboard/.dashboard
usagetemptmp=/tmp/eww/dashboard/.usagetemp
cputmp=/tmp/eww/dashboard/.cpu
gputmp=/tmp/eww/dashboard/.gpu
timertmp=/tmp/eww/dashboard/.timer
timerstartedtmp=/tmp/eww/dashboard/.timerstarted
timerpausedtmp=/tmp/eww/dashboard/.timerpaused
timerstatetmp=/tmp/eww/dashboard/.timerstate
daytmp=/tmp/eww/dashboard/.day
switchdaytmp=/tmp/eww/dashboard/.switchday
weathertmp=/tmp/eww/dashboard/.weather
dashboardwidgets=(background folders hardwareinfo switch fullhardwareinfo apps timer user host musicplayer quote weather daytime todo colorpicker nightlight lock power)

param=$1

currenttheme=$(tail -n 1 $hyprlandconf | sed -E "s|.*([0-9]).*|\1|")

case $param in
	desktop)
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
		ghostty --class=com.file.manager -e yazi $HOME/desktop/
	;;
	documents)
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
		ghostty --class=com.file.manager -e yazi $HOME/documents/
	;;
	downloads)
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
		ghostty --class=com.file.manager -e yazi $HOME/downloads/
	;;
	images)
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
		ghostty --class=com.file.manager -e yazi $HOME/images/
	;;
	music)
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
		ghostty --class=com.file.manager -e yazi $HOME/music/
	;;
	scripts)
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
		ghostty --class=com.file.manager -e yazi $HOME/.config/scripts/
	;;
	usagetemp)
		current=$(head -n 1 "${usagetemptmp}")
		if [[ "$current" == *""* ]]; then
			sed -i '1s||󱨄|' "${usagetemptmp}"
			cpuinfo="$($HOME/.config/hypr/scripts/sysinfo/cpuUsage.sh load)"
			if [[ "$cpuinfo" -le "7" ]]; then
				sed -i "1s|.*|8|" "$cputmp"
			else
	   	 		sed -i "1s|.*|$cpuinfo|" "$cputmp"
	   	 	fi
	   	 	gpuinfo="$($HOME/.config/hypr/scripts/sysinfo/nvidiaUsage.sh load)"
 			if [[ "$gpuinfo" -le "7" ]]; then
 				sed -i "1s|.*|8|" "$gputmp"
 			else
 	   	 		sed -i "1s|.*|$gpuinfo|" "$gputmp"
 	   	 	fi
		else
			sed -i '1s|󱨄||' "${usagetemptmp}"
			cpuinfo="$($HOME/.config/hypr/scripts/sysinfo/cpuUsage.sh temp)"
		    sed -i "1s|.*|$cpuinfo|" "$cputmp"
		    gpuinfo="$($HOME/.config/hypr/scripts/sysinfo/nvidiaUsage.sh temp)"
    	    sed -i "1s|.*|$gpuinfo|" "$gputmp"
		fi
	;;
	fullhardwareinfo)
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
		isrunning=/tmp/eww/sysinfo/.sysinforunning
		screen=/tmp/eww/sysinfo/.sysinfoscreen
		if [ -e $isrunning ]; then
		    eww -c ~/.config/eww_1/sysinfo/ close-all
		    rm -f $isrunning
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
	steam)
		steam &
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
	;;
	heroic)
		heroic &
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
	;;
	vesktop)
		vesktop &
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
 	;;
	stremio)
		QT_QPA_PLATFORM=xcb stremio &
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
	;;
	gmail)
		zen --new-tab 'gmail.com' &
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
	;;
	zen)
		zen &
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
	;;
	spotify)
		spotify &
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
	;;
	youtube)
		zen --new-tab 'youtube.com'
		$HOME/.config/scripts/eww/widgethandler.sh dashboard
	;;
	slurp)
		if [[ -e /tmp/eww/dashboard/.dashboard ]]; then
			$HOME/.config/scripts/eww/widgethandler.sh dashboard
		fi
        geometry=$(slurp) || exit 1
        dimension=$(echo "$geometry" | awk '{printf "%s", $2}')
        echo -n "$dimension" | wl-copy
        notify-send "Slurp" "$dimension"
	;;
	timer)
		eww -c $HOME/.config/eww_1/dashboard/ poll timer
		if [ -e "$timerpausedtmp" ];then
			sed -i "s|.*||" "$timerstatetmp"
			rm -rf $timerpausedtmp $timerstartedtmp
		elif [ -e "$timerstartedtmp" ]; then
			currenttime=$(date +%s)
			echo "$currenttime" >> "$timerpausedtmp"
			sed -i "s|.*|󰑐|" "$timerstatetmp"
		else
			starttime=$(date +%s)
			echo "$starttime" >> $timerstartedtmp
			sed -i "s|.*||" "$timerstatetmp"
		fi
	;;
	weatherday)
		current=$(cat $daytmp)
		today=$(date +%e)
		tomorrow=$((today+1))
		if [[ "$tomorrow" == "32" ]]; then
			tomorrow="1"
		fi
		if [[ "$current" == "$today" ]]; then
			sed -i "1s|.*|${tomorrow}|" "$daytmp"
			sed -i "1s|.*||" "$switchdaytmp"
			#$HOME/.config/scripts/eww/dashboard/forecasting.sh tomorrow
			map=(
				5
				6
				7
				8
				1
				2
				3
				4
			)
		else
			sed -i "1s|.*|${today}|" "$daytmp"
			sed -i "1s|.*||" "$switchdaytmp"
			#$HOME/.config/scripts/eww/dashboard/forecasting.sh today
			map=(
				5
				6
				7
				8
				1
				2
				3
				4
			)
		fi
		map_str=$(IFS=,; echo "${map[*]}")
		awk -v map="$map_str" '
		BEGIN {
		  split(map, m, ",")  # Split on comma instead of space
		}
		{
		  lines[NR] = $0  # Store each line
		}
		END {
		  for (i = 1; i <= length(m); i++) {
		    print lines[m[i]]  # Print in the new order
		  }
		}
		' "$weathertmp" > tempfile && mv tempfile "$weathertmp"
		eww -c $HOME/.config/eww_1/dashboard/ poll morning noon evening night
	;;
	todo)
		ghostty -e micro $HOME/documents/todo.txt &
		if [[ -e /tmp/eww/dashboard/.dashboard ]]; then
			$HOME/.config/scripts/eww/widgethandler.sh dashboard
		fi
	;;
	colorpicker)
		if [[ -e /tmp/eww/dashboard/.dashboard ]]; then
			$HOME/.config/scripts/eww/widgethandler.sh dashboard
		fi
		(sleep 0.4 && hyprpicker | tr -d '\n' | wl-copy) &
	;;
	nightlight)
		if pgrep -x "hyprsunset" > /dev/null; then
			pkill -2 hyprsunset
		else
			hyprsunset -t 3300
		fi
	;;
	lock)
		if [[ -e /tmp/eww/dashboard/.dashboard ]]; then
			$HOME/.config/scripts/eww/widgethandler.sh dashboard
		fi
		hyprlock -c "$HOME/.config/hypr/hyprlock${currenttheme}.conf"
	;;
	power)
		if [[ -e /tmp/eww/dashboard/.dashboard ]]; then
			$HOME/.config/scripts/eww/widgethandler.sh dashboard
		fi
		ghostty --class=com.power.button -e doas halt &
	;;
esac
	
