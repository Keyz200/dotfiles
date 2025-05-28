#!/bin/sh
# config paths
hyprlandconf=/home/keyz/.config/hypr/hyprland.conf
hyprpaperconf=/home/keyz/.config/hypr/hyprpaper.conf
hyprlockconf=/home/keyz/.config/hypr/hyprlock.conf
waybarconf=/home/keyz/.config/waybar
woficonf=/home/keyz/.config/wofi
ewwconf=/home/keyz/.config/eww_1
fastfetchconf=/home/keyz/.config/fastfetch

# wallpapers
theme4wallpaper="/home/keyz/images/wallpapers/trine-2-goblin-menace-artwork-gt.jpg"
theme3wallpaper="/home/keyz/images/wallpapers/340682-2055502627.jpg"
theme2wallpaper="/home/keyz/images/wallpapers/wallhaven-l8oody.png"
theme1wallpaper="/home/keyz/images/wallpapers/wallhaven-exdqpo.jpg"

# theme amount
totalthemes="4"

# close dashboard/menu
if [[ -e "/tmp/eww/dashboard/.dashboard" ]]; then
	$HOME/.config/scripts/eww/widgethandler.sh dashboard &
else
	eww -c $HOME/.config/eww_1/bar/ update menutoggle0=false
	eww -c $HOME/.config/eww_1/bar/ update menutoggle=false
	rm -rf /tmp/eww/bar/.menu
fi

# get current theme from hypland.conf
currenttheme=$(tail -n 1 $hyprlandconf | sed -E "s|.*([0-9]).*|\1|")

# select new theme #
newtheme=$((currenttheme + 1))
if [[ $newtheme -gt $totalthemes ]]; then
	newtheme="1"
fi

# hyprland #
sed -i -E "s|(theme)[0-9]|\1$newtheme|" "$hyprlandconf"
hyprctl reload

# hyprpaper #
newwallpaperpath="theme${newtheme}wallpaper"
newwallpaperfull=$(eval "echo \${$newwallpaperpath}")
newwallpaper=$(echo "$newwallpaperfull" | sed -E 's|.*/wallpapers/||')

eval "hyprctl hyprpaper reload HDMI-A-1, \"\${$newwallpaperpath}\""
eval "hyprctl hyprpaper reload DP-2, \"\${$newwallpaperpath}\""
sed -i -E "s|(wallpapers/)(.*)#|\1$newwallpaper#|g" "$hyprpaperconf"

# waybar #
ln -sf $waybarconf/theme$newtheme/config $waybarconf/config
ln -sf $waybarconf/theme$newtheme/style.css $waybarconf/style.css
killall waybar

# wofi #
ln -sf $woficonf/theme$newtheme.css $woficonf/style.css

# eww #
# dashboard
ln -sf $ewwconf/dashboard/theme$newtheme.scss $ewwconf/dashboard/eww.scss
ln -sf $ewwconf/dashboard/theme$newtheme.yuck $ewwconf/dashboard/eww.yuck
eww -c ~/.config/eww_1/dashboard/ daemon
# music player
ln -sf $ewwconf/musicplayer/theme$newtheme.scss $ewwconf/musicplayer/eww.scss
ln -sf $ewwconf/musicplayer/theme$newtheme.yuck $ewwconf/musicplayer/eww.yuck
# notifications
ln -sf $ewwconf/notifications/theme$newtheme.scss $ewwconf/notifications/eww.scss
ln -sf $ewwconf/notifications/theme$newtheme.yuck $ewwconf/notifications/eww.yuck
eww -c ~/.config/eww_1/notifications close-all
for i in $(seq 1 5); do
	rm -rf /tmp/eww/notifications/.notifier$i
done
eww -c ~/.config/eww_1/notifications daemon
# sysinfov2
ln -sf $ewwconf/sysinfov2/theme$newtheme.scss $ewwconf/sysinfov2/eww.scss
ln -sf $ewwconf/sysinfov2/theme$newtheme.yuck $ewwconf/sysinfov2/eww.yuck
# waybarbg
if [[ "$newtheme" == "3" ]]; then
	eww -c $ewwconf/waybarbg/ open busterswordleft
	eww -c $ewwconf/waybarbg/ open busterswordleft2
	eww -c $ewwconf/waybarbg/ open busterswordright
	eww -c $ewwconf/waybarbg/ open busterswordright2
elif [[ "$currenttheme" == "3" ]]; then
	eww -c $ewwconf/waybarbg/ close busterswordleft
	eww -c $ewwconf/waybarbg/ close busterswordleft2
	eww -c $ewwconf/waybarbg/ close busterswordright
	eww -c $ewwconf/waybarbg/ close busterswordright2
fi
# bar
if [[ "$newtheme" == "4" ]]; then
	$HOME/.config/scripts/eww/dashboard/forecasting.sh
	eww -c "$ewwconf/sysinfov2/" close hovertrigger
	eww -c "$ewwconf/bar/" open sword
	eww -c "$ewwconf/bar/" open sword0
	sleep 0.1
	eww -c "$ewwconf/bar/" open bar
	eww -c "$ewwconf/bar/" open bar0
	eww -c "$ewwconf/bar/" open menurev
	eww -c "$ewwconf/bar/" open menurev0
elif [[ "$currenttheme" == "4" ]]; then
	eww -c "$ewwconf/bar/" update menutoggle=false &
	eww -c "$ewwconf/bar/" close bar &
	eww -c "$ewwconf/bar/" close bar0 &
	eww -c "$ewwconf/bar/" close sword &
	eww -c "$ewwconf/bar/" close sword0 &
	eww -c "$ewwconf/bar/" close menurev &
	eww -c "$ewwconf/bar/" close menurev0 &
	eww -c "$ewwconf/sysinfov2/" open hovertrigger &
fi

# fastfetch
ln -sf $fastfetchconf/theme$newtheme.jsonc $fastfetchconf/config.jsonc

# vesktop
vesktopbg=$(head -n 1 $HOME/images/vesktopbgs/theme$newtheme | tr -d '\n')
vesktopaccentcolor=$(head -n 2 $HOME/images/vesktopbgs/theme$newtheme | tail -n 1 | tr -d '\n')
printf '%s\n' \
  'g/--background-image-url: url(/s|--background-image-url: url('\''[^'\'']*'\''|--background-image-url: url('\'''"${vesktopbg}"''\''|' \
  'g/--yellow-2: #/s/--yellow-2: #[^;]*/--yellow-2: #'"${vesktopaccentcolor}"'/' \
  'g/--yellow-3: #/s/--yellow-3: #[^;]*/--yellow-3: #'"${vesktopaccentcolor}"'/' \
  'w' 'q' | ed -s "$HOME/.config/vesktop/settings/quickCss.css"

sleep 0.1
waybar &
notify-send "System" "Theme changed"
