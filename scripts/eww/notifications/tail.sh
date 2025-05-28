#!/bin/sh
processcheck=$(pgrep -f "tail.sh")
if [ "$processcheck" == "" ]; then
  exit 1
fi
notificationtmp=/tmp/eww/notifications/.notification
apptmp=/tmp/eww/notifications/.app
sendertmp=/tmp/eww/notifications/.sender
contenttmp=/tmp/eww/notifications/.content
icontmp=/tmp/eww/notifications/.icon
notifier1tmp=/tmp/eww/notifications/.notifier1
notifier2tmp=/tmp/eww/notifications/.notifier2
notifier3tmp=/tmp/eww/notifications/.notifier3
notifier4tmp=/tmp/eww/notifications/.notifier4
notifier5tmp=/tmp/eww/notifications/.notifier5
dummytmp=/tmp/eww/notifications/.dummy

param=$1


lockfile=/tmp/eww/notifications/.lock

acquire_lock() {
  exec 9>"$lockfile"
  flock -n 9 || exit 1
}

release_lock() {
  flock -u 9
  rm -f "$lockfile"
}


shift_notifications() {
  mv "$notifier4tmp" "$notifier5tmp"
  mv "$notifier3tmp" "$notifier4tmp"
  mv "$notifier2tmp" "$notifier3tmp"
  mv "$notifier1tmp" "$notifier2tmp"
  echo "$(date +%s)" > "$notifier1tmp"
}

notifyopen() {
  dummy=$(cat $dummytmp)
  if [[ "$dummy" != "a" ]]; then
    if [[ $1 == "5" ]]; then # last notification visible
      shift_notifications
    elif [[ $1 != "1" ]]; then # if not the first notify move files
      movefiles=$(($1 - 1))
      for i in $(seq $movefiles -1 1); do
        j=$((i + 1))
        notifiertmp1var="notifier${i}tmp"
        notifiertmp2var="notifier${j}tmp"
        notifiertmp1=$(eval "echo \${$notifiertmp1var}")
        notifiertmp2=$(eval "echo \${$notifiertmp2var}")
        mv $notifiertmp1 $notifiertmp2
        sleep 0.1
      done
    fi
    
    echo "$(date +%s)" > "$notifier1tmp"
    
    if [[ "$currenttheme" =~ ^(3|4)$ ]]; then
      eww -c ~/.config/eww_1/notifications/ open notifrev$1 && eww -c ~/.config/eww_1/notifications/ update animate${1}=true
      $HOME/.config/scripts/eww/notifications/cleanup.sh $1 "on" &
    else
      eww -c $HOME/.config/eww_1/notifications/ open notification$1
      $HOME/.config/scripts/eww/notifications/cleanup.sh $1 "off" &
    fi
  fi
}

tail -F "$dummytmp" | while read -r line; do
  acquire_lock || continue
  if [[ $param = "skip" ]]; then
    skip="1"
  else
    skip="0"
  fi

  currenttheme=$(tail -n 1 /home/keyz/.config/hypr/hyprland.conf | sed -E "s|.*([0-9]).*|\1|")
  
  # icons
  terminalicon="/home/keyz/images/icons/theme${currenttheme}/terminal.png"
  brushicon="/home/keyz/images/icons/theme${currenttheme}/brush.png"
  sysinfoicon="/home/keyz/images/icons/theme${currenttheme}/sysinfopin.png"
  ytdlpicon="/home/keyz/images/icons/theme${currenttheme}/ytdlp.png"
  notifysendicon="/home/keyz/images/icons/theme${currenttheme}/notifysend.png"
  vesktopicon="/home/keyz/images/icons/theme${currenttheme}/vesktop.png"
  lookicon="/home/keyz/images/icons/theme${currenttheme}/look.png"
  wiishicon="/home/keyz/images/icons/theme${currenttheme}/WIISH.png"
  spotifyicon="/home/keyz/images/icons/theme${currenttheme}/spotify.png"

  for i in $(seq 1 15); do
    if [[ "$skip" != "1" ]]; then
      if [[ "$i" =~ ^(1|4|7|10|13)$ ]]; then
        line=$(head -n $i $notificationtmp | tail -n 1)
        sendernum=$((i + 1))
        sender=$(head -n $sendernum $notificationtmp | tail -n 1)
        contentnum=$((i + 2))
        content=$(head -n $contentnum $notificationtmp | tail -n 1)
        if [[ "$line" =~ (notify-send) ]]; then
          if [[ "$sender" =~ (Done|Failed) ]]; then
            sed -i "s|.*|${terminalicon}|" "${icontmp}${i}"
          elif [[ "$sender" =~ (Sysinfo) ]]; then
            sed -i "s|.*|${sysinfoicon}|" "${icontmp}${i}"
          elif [[ "$sender" =~ (YT-DLP) ]]; then
            sed -i "s|.*|${ytdlpicon}|" "${icontmp}${i}"
          elif [[ "$content" == "Theme changed" ]]; then
            sed -i "s|.*|${brushicon}|" "${icontmp}${i}"
          else
            sed -i "s|.*|${notifysendicon}|" "${icontmp}${i}"
          fi
        elif [[ "$line" =~ (vesktop) ]]; then
            if [[ "$sender" =~ (WIISH) ]];then
              sed -i "s|.*|${wiishicon}|" "${icontmp}${i}"
            elif [[ "$sender" =~ (look) ]]; then
              sed -i "s|.*|${lookicon}|" "${icontmp}${i}"
            else
              sed -i "s|.*|${vesktopicon}|" "${icontmp}${i}"
            fi
        elif [[ "$line" =~ (Spotify) ]]; then
          skip="1" # skips notifications from apps
          # sed -i "s|.*|${spotifyicon}|" "${icontmp}${i}"
        else
          sed -i "s|.*|${line}|" "${apptmp}${i}"
        fi
      elif [[ "$i" =~ ^(2|5|8|11|14)$ ]]; then
        line=$(head -n $i $notificationtmp | tail -n 1)
        sed -i "s|.*|${line}|" "${sendertmp}${i}"
      elif [[ "$i" =~ ^(3|6|9|12|15)$ ]]; then
        line=$(head -n $i $notificationtmp | tail -n 1)
        line=$(echo "$line" | sed 's/ \&/ \\\&/')
        sed -i "s|.*|${line}|" "${contenttmp}${i}"
      fi
    fi
  done

  if [[ "$skip" != "1" ]]; then
    if [ -e "$notifier1tmp" ]; then
      if [ -e "$notifier2tmp" ]; then
        if [ -e "$notifier3tmp" ]; then
          if [ -e "$notifier4tmp" ]; then
            if [ ! -e "$notifier5tmp" ]; then
              notifyopen "5"
            fi
          else
            notifyopen "4"
          fi
        else
          notifyopen "3"
        fi
      else
        notifyopen "2"
      fi
    else
      notifyopen "1"
    fi
    head -n 15 $notificationtmp > /tmp/eww/.notificationtmp && mv /tmp/eww/.notificationtmp $notificationtmp
  else
    a=$(head -n 18 $notificationtmp | tail --lines=+4)
    echo "$a" > /tmp/eww/.notificationtmp && mv /tmp/eww/.notificationtmp $notificationtmp
    skip="0"
    param="a"
  fi
  release_lock
done

