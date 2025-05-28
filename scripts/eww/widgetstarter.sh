#!/bin/sh
currenttheme=$(tail -n 1 /home/keyz/.config/hypr/hyprland.conf | sed -E "s|.*([0-9]).*|\1|")
if [[ -e /tmp/eww ]]; then
	rm -rf /tmp/eww/
fi

mkdir /tmp/eww/ /tmp/eww/sysinfo/ /tmp/eww/dashboard/ /tmp/eww/musicplayer/ /tmp/eww/notifications/ /tmp/eww/bar/

# notifications
for i in $(seq 1 15); do
    if [[ "$i" =~ ^(1|4|7|10|13)$ ]]; then
        echo "a" > /tmp/eww/notifications/.app$i
        echo "a" > /tmp/eww/notifications/.icon$i
    elif [[ "$i" =~ ^(2|5|8|11|14)$ ]]; then
        echo "a" > /tmp/eww/notifications/.sender$i
    elif [[ "$i" =~ ^(3|6|9|12|15)$ ]]; then
        echo "a" > /tmp/eww/notifications/.content$i
    fi
done
echo "a" > /tmp/eww/notifications/.dummy

# dashboard
echo "" > /tmp/eww/dashboard/.usagetemp
echo "a" > /tmp/eww/dashboard/.cpu
echo "a" > /tmp/eww/dashboard/.gpu
echo "" > /tmp/eww/dashboard/.timerstate
today=$(date +%e)
echo "$today" > /tmp/eww/dashboard/.day
echo "" > /tmp/eww/dashboard/.switchday
# weather
i=1
while [ "$i" -lt 9 ]; do
    echo "a" > "/tmp/eww/dashboard/.weather"
    i=$((i + 1))
done
# sysinfo
touch /tmp/eww/sysinfo/.sysinfoscreen0
# music player
touch /tmp/eww/musicplayer/.musicplayerscreen0
touch /tmp/eww/musicplayer/.spotifymusicplayerrunning
echo "" > /tmp/eww/musicplayer/.playpause
# bar
echo "" > /tmp/eww/bar/.volumeicon
echo "" > /tmp/eww/bar/.micicon
echo "󰞃" > /tmp/eww/bar/.neticon
# daemons
eww -c ~/.config/eww_1/musicplayer/ daemon
eww -c ~/.config/eww_1/sysinfo/ daemon
eww -c ~/.config/eww_1/sysinfov2/ daemon
eww -c ~/.config/eww_1/dashboard/ daemon
eww -c ~/.config/eww_1/notifications/ daemon
# opening widgets
if [[ "$currenttheme" == "3" ]]; then
    eww -c ~/.config/eww_1/waybarbg/ open busterswordleft
    eww -c ~/.config/eww_1/waybarbg/ open busterswordleft2
	eww -c ~/.config/eww_1/waybarbg/ open busterswordright
	eww -c ~/.config/eww_1/waybarbg/ open busterswordright2
elif [[ "$currenttheme" == "4" ]]; then
    eww -c ~/.config/eww_1/bar/ open sword
    eww -c ~/.config/eww_1/bar/ open sword0
    sleep 0.1
    eww -c ~/.config/eww_1/bar/ open bar
    eww -c ~/.config/eww_1/bar/ open bar0
    eww -c $HOME/.config/eww_1/bar/ open menurev
    eww -c $HOME/.config/eww_1/bar/ open menurev0
fi
############
$HOME/.config/scripts/eww/bar/updatevalues.sh &
$HOME/.config/scripts/eww/dashboard/updatevalues.sh &
$HOME/.config/scripts/eww/dashboard/quoter.sh quote &
$HOME/.config/scripts/eww/dashboard/forecasting.sh &
$HOME/.config/scripts/eww/notifications/dbusmonitor.sh &
$HOME/.config/scripts/eww/notifications/tail.sh &

