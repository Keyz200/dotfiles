#!/usr/bin/env bash

handle() {
  IFS=',' read -r -a args <<< "${1#*>>}"
  case $1 in
    activewindowv2*)
      ACTIVE_WINDOW=${args[0]}
    ;;
    openwindow*)
      if [[ ${args[2]} == "steam_app_739630" ]]; then
        PHASMO_ADDRESS=${args[0]}
        hyprctl keyword decoration:screen_shader '$XDG_CONFIG_HOME/hypr/shaders/bright.frag'
        $XDG_CONFIG_HOME/hypr/scripts/phasmophobia/run_chronometer.sh
      fi
    ;;
    closewindow*)
      # Disable phasmo stuff
      if [[ ${args[0]} == $PHASMO_ADDRESS ]]; then
        $XDG_CONFIG_HOME/phasmometer/chronometer_cmd.py exit
        hyprctl keyword decoration:screen_shader ''
      fi
    ;;
    fullscreen*)
      # Make chronometer on top
      if [[ ${args[0]} == 1 && $ACTIVE_WINDOW == $PHASMO_ADDRESS ]]; then
        hyprctl dispatch alterzorder top, title:Chronometer
        hyprctl dispatch workspace 7
        hyprctl dispatch workspace 1
      fi
    ;;
  esac
}

socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
