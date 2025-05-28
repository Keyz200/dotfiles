#!/bin/sh

## Files and Data
PREV_TOTAL=0
PREV_IDLE=0
cpuFile="/tmp/.cpu_usage"
param="$1"

## Get CPU usage
case $param in
	load)
		if [[ -f "${cpuFile}" ]]; then
			fileCont=$(cat "${cpuFile}")
			PREV_TOTAL=$(echo "${fileCont}" | head -n 1)
			PREV_IDLE=$(echo "${fileCont}" | tail -n 1)
		fi

		CPU=(`cat /proc/stat | grep '^cpu '`) # Get the total CPU statistics.
		unset CPU[0]                          # Discard the "cpu" prefix.
		IDLE=${CPU[4]}                        # Get the idle CPU time.

		# Calculate the total CPU time.
		TOTAL=0

		for VALUE in "${CPU[@]:0:4}"; do
			let "TOTAL=$TOTAL+$VALUE"
		done

		if [[ "${PREV_TOTAL}" != "" ]] && [[ "${PREV_IDLE}" != "" ]]; then
			# Calculate the CPU usage since we last checked.
			let "DIFF_IDLE=$IDLE-$PREV_IDLE"
			let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
			let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
			echo "${DIFF_USAGE}"
		else
			echo "?"
		fi

		# Remember the total and idle CPU times for the next check.
		echo "${TOTAL}" > "${cpuFile}"
		echo "${IDLE}" >> "${cpuFile}"
	;;
	temp)
		cat /sys/class/hwmon/hwmon4/temp1_input | sed -E 's/^([0-9]{2}).*/\1/'
	;;
	name)
		cat /proc/cpuinfo | grep -i 'model name' | head -n 1 | sed -E "s|model name.*:(.*).*|\1|" | awk '{printf "%s\n", $5}'
	;;
	clock)
		awk -F ': ' '/cpu MHz/ {if ($2 > max) max = $2} END {print max}' /proc/cpuinfo | sed -E "s|(.*)\..*|\1|"
	;;
	watts)
		E1=$(doas cat /sys/class/powercap/intel-rapl:0/energy_uj)
		T1=$(date +%s%N)
		
		sleep 1
		
		E2=$(doas cat /sys/class/powercap/intel-rapl:0/energy_uj)
		T2=$(date +%s%N)
		
		DELTA_E=$((E2 - E1))       # in microjoules
		DELTA_T=$((T2 - T1))       # in nanoseconds
		
		# Avoid divide by zero
		if [ "$DELTA_T" -eq 0 ]; then
		    echo "Error: ΔTime is 0"
		    exit 1
		fi
		
		# Convert power: (ΔE * 1000) / ΔT = watts × 100 (2 decimal places)
		POWER_MILLIWATTS=$(( (DELTA_E * 100000) / DELTA_T ))
		
		# Split integer and decimal
		WATTS_INT=$((POWER_MILLIWATTS / 100))
		WATTS_DEC=$((POWER_MILLIWATTS % 100))
		
		watts=$(printf "%d.%02d\n" "$WATTS_INT" "$WATTS_DEC" | sed -E "s|(.*)\..*|\1|")
		echo "$watts"
	;;
esac
