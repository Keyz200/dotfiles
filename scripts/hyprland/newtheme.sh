#!/bin/sh
param1=$1 # new theme number
param2=$2 # theme to copy from
param3=$3 # wallpaper full path

# eww
cp $HOME/.config/eww_1/dashboard/theme$param2.scss $HOME/.config/eww_1/dashboard/theme$param1.scss
cp $HOME/.config/eww_1/dashboard/theme$param2.yuck $HOME/.config/eww_1/dashboard/theme$param1.yuck
cp $HOME/.config/eww_1/musicplayer/theme$param2.scss $HOME/.config/eww_1/musicplayer/theme$param1.scss 
cp $HOME/.config/eww_1/musicplayer/theme$param2.yuck $HOME/.config/eww_1/musicplayer/theme$param1.yuck 
cp $HOME/.config/eww_1/notifications/theme$param2.scss $HOME/.config/eww_1/notifications/theme$param1.scss 
cp $HOME/.config/eww_1/notifications/theme$param2.yuck $HOME/.config/eww_1/notifications/theme$param1.yuck 
cp $HOME/.config/eww_1/sysinfov2/theme$param2.scss $HOME/.config/eww_1/sysinfov2/theme$param1.scss 
cp $HOME/.config/eww_1/sysinfov2/theme$param2.yuck $HOME/.config/eww_1/sysinfov2/theme$param1.yuck

# hyprland
cp $HOME/.config/hypr/theme$param2.conf $HOME/.config/hypr/theme$param1.conf

# hyprlock
cp $HOME/.config/hypr/hyprlock$param2.conf $HOME/.config/hypr/hyprlock$param1.conf

# hyprpaper
sed -i "1i preload = ${param3}" "$HOME/.config/hypr/hyprpaper.conf"

# waybar
cp -r $HOME/.config/waybar/theme$param2 $HOME/.config/waybar/theme$param1

# wofi
cp $HOME/.config/wofi/theme$param2.css $HOME/.config/wofi/theme$param1.css

# fastfetch
cp $HOME/.config/fastfetch/theme$param2.jsonc $HOME/.config/fastfetch/theme$param1.jsonc
# changes inside the themechange.sh script
# increase totaltheme number
sed -i -E "s|(totalthemes=\")[0-9]+|\1${param1}|" "$HOME/.config/scripts/hyprland/themechange.sh"
# add new theme's wallpaper
sed -i "12i theme${param1}wallpaper=\"${param3}\"" "$HOME/.config/scripts/hyprland/themechange.sh"
