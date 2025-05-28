#!/bin/sh
hyprlandconf="$HOME/.config/hypr/hyprland.conf"
calendartmp=/tmp/eww/bar/.calendar
volumeicontmp=/tmp/eww/bar/.volumeicon
micicontmp=/tmp/eww/bar/.micicon
menutmp=/tmp/eww/bar/.menu
param=$1
currenttheme=$(tail -n 1 $hyprlandconf | sed -E "s|.*([0-9]).*|\1|")
focusedmonitorname=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

case $param in
	togglecalendar)
		if [[ -e $calendartmp ]]; then
			eww -c $HOME/.config/eww_1/bar/ close calendar
			rm -rf $calendartmp
		else
			if [[ "$focusedmonitorname" == *"HDMI"* ]]; then
				eww -c $HOME/.config/eww_1/bar/ open calendar --arg screen=0
			else 
				eww -c $HOME/.config/eww_1/bar/ open calendar --arg screen=1
			fi
			touch $calendartmp
		fi
	;;
	togglevolume)
		ismuted=$(pamixer --get-volume)
		if [[ "$ismuted" == "0" ]]; then
			pamixer --set-volume 100
			sed -i "1s|.*||" "$volumeicontmp"
		else
			pamixer --set-volume 0
			sed -i "1s|.*||" "$volumeicontmp"
		fi
	;;
	togglemic)
		ismuted=$(pamixer --default-source --get-volume)
		if [[ "$ismuted" == "0" ]]; then
			pamixer --default-source --set-volume 100
			sed -i "1s|.*||" "$micicontmp"
		else
			pamixer --default-source --set-volume 0
			sed -i "1s|.*||" "$micicontmp"
			echo "a"
		fi
	;;
	menutoggle)
		if [[ -e $menutmp ]]; then
			monitor=$(head -n 1 $menutmp)
			eww -c $HOME/.config/eww_1/bar/ update menutoggle$monitor=false
			rm -rf $menutmp
		else
			if [[ "$focusedmonitorname" == *"HDMI"* ]]; then
				eww -c $HOME/.config/eww_1/bar/ update menutoggle0=true
				echo "0" > $menutmp
			else
				eww -c $HOME/.config/eww_1/bar/ update menutoggle=true
				touch $menutmp
			fi
		fi
	;;
	todo)
		ghostty -e micro $HOME/documents/todo.txt &
	;;
	steam)
		steam &
	;;
	heroic)
		heroic &
	;;
	vesktop)
		vesktop &
	;;
	stremio)
		QT_QPA_PLATFORM=xcb stremio &
	;;
	home)
		ghostty -e micro $HOME//canis-major/canis-major/keyz.scm &
	;;
	slurp)
		geometry=$(slurp) || exit 1
		echo "$geometry"
        dimension=$(echo "$geometry" | awk '{printf "%s", $2}')
        echo -n "$dimension" | wl-copy
        notify-send "Slurp" "$dimension"
    ;;
    hyprpicker)
    	eww -c $HOME/.config/eww_1/bar/ update menutoggle=false
    	rm -rf $menutmp
    	(sleep 0.4 && hyprpicker | tr -d '\n' | wl-copy) &
    ;;
    lock)
    	$HOME/.config/scripts/hyprland/hyprlock.sh &
    	eww -c $HOME/.config/eww_1/bar/ update menutoggle=false
    	rm -rf $menutmp
    ;;
	togglenightlight)
		ison=$(eww -c $HOME/.config/eww_1/bar get nightlightbox)
		echo "$ison"
		if [[ "$ison" == *"nightlightboxon"* ]]; then
			eww -c $HOME/.config/eww_1/bar update nightlightbox="sidebuttonbox"
			pkill -2 hyprsunset
		else
			eww -c $HOME/.config/eww_1/bar update nightlightbox="nightlightboxon"
			hyprsunset -t 3300
		fi
	;;
	tab1button)
		eww -c $HOME/.config/eww_1/bar/ update tabbutton1box="tabbuttonboxselected"
		eww -c $HOME/.config/eww_1/bar/ update tab1visible=true
		eww -c $HOME/.config/eww_1/bar/ update tab2visible=false
		eww -c $HOME/.config/eww_1/bar/ update tab3visible=false
		eww -c $HOME/.config/eww_1/bar/ update tabbutton2box="tabbuttonbox"
		eww -c $HOME/.config/eww_1/bar/ update tabbutton3box="tabbuttonbox"
	;;
	tab2button)
		eww -c $HOME/.config/eww_1/bar/ update tabbutton2box="tabbuttonboxselected"
		eww -c $HOME/.config/eww_1/bar/ update tab2visible=true
		eww -c $HOME/.config/eww_1/bar/ update tab1visible=false
		eww -c $HOME/.config/eww_1/bar/ update tab3visible=false
		eww -c $HOME/.config/eww_1/bar/ update tabbutton1box="tabbuttonbox"
		eww -c $HOME/.config/eww_1/bar/ update tabbutton3box="tabbuttonbox"
	;;
	tab3button)
		eww -c $HOME/.config/eww_1/bar/ update tabbutton3box="tabbuttonboxselected"
		eww -c $HOME/.config/eww_1/bar/ update tab3visible=true
		eww -c $HOME/.config/eww_1/bar/ update tab1visible=false
		eww -c $HOME/.config/eww_1/bar/ update tab2visible=false
		eww -c $HOME/.config/eww_1/bar/ update tabbutton1box="tabbuttonbox"
		eww -c $HOME/.config/eww_1/bar/ update tabbutton2box="tabbuttonbox"
	;;
esac
