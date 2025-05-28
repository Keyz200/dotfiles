#!/bin/sh
usagetemptmp=/tmp/eww/dashboard/.usagetemp
gputmp=/tmp/eww/dashboard/.gpu
cputmp=/tmp/eww/dashboard/.cpu
cpuinfo=$($HOME/.config/scripts/hardwareinfo/cpuUsage.sh load)
gpuinfo=$($HOME/.config/scripts/hardwareinfo/nvidiaUsage.sh load)

if [ ! -f "$usagetemptmp" ]; then
	echo "" >> $usagetemptmp
	echo "${cpuinfo}" >> $cputmp
	echo "${gpuinfo}" >> $gputmp
else
	sed -i "1s|.*|$cpuinfo|" "$cputmp"
	sed -i "1s|.*|$gpuinfo|" "$gputmp"
fi

while true; do
	decider=$(cat $usagetemptmp)
	if [[ "$decider" == *""* ]]; then
	    cpuinfo="$($HOME/.config/scripts/hardwareinfo/cpuUsage.sh temp)"
	    sed -i "1s|.*|$cpuinfo|" "$cputmp"
	    gpuinfo="$($HOME/.config/scripts/hardwareinfo/nvidiaUsage.sh temp)"
	    sed -i "1s|.*|$gpuinfo|" "$gputmp"
        sleep 2
	else
		cpuinfo="$($HOME/.config/scripts/hardwareinfo/cpuUsage.sh load)"
		if [[ "$cpuinfo" -le "7" ]]; then
			sed -i "1s|.*|8|" "$cputmp"
		else
   	 		sed -i "1s|.*|$cpuinfo|" "$cputmp"
   	 	fi
		gpuinfo="$($HOME/.config/scripts/hardwareinfo/nvidiaUsage.sh load)"
		if [[ "$gpuinfo" -le "7" ]]; then
			sed -i "1s|.*|8|" "$gputmp"
		else
   	 		sed -i "1s|.*|$gpuinfo|" "$gputmp"
   	 	fi
		sleep 2
	fi
done
