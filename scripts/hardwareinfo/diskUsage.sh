#!/bin/sh
param="$1"

case $param in
	usage1)
		if [ -r "/sys/block/nvme0n1/size" ]; then
		    sectors=$(cat "/sys/block/nvme0n1/size")
		    bytes=$(expr "$sectors" \* 512)
		    gb=$(expr "$bytes" / 1024 / 1024 / 1024)
		    size="${gb}GB"
		    
		    echo "$size"
		fi
	;;
	usage0)
		df -h /boot | awk '{printf "%.0f/%.0fGB (%.0f%)\n", $3, $2, $5}' | tail -n1
	;;
	temp0)
		cat /sys/class/hwmon/hwmon1/temp3_input | sed -E 's/^([0-9]{2}).*/\1°C/'
	;;
	temp1)
		cat /sys/class/hwmon/hwmon2/temp3_input | sed -E 's/^([0-9]{2}).*/\1°C/'
	;;
	name0)
		nvme list-subsys | sed -E "s|[^.]+\.[^.]+\.[^.]+\.([A-Za-z]+):.*:([0-9]+).*|\1 \2|" | sed -n '1p'
  	;;
	name1)
		nvme list-subsys | sed -E "s|[^.]+\.[^.]+\.[^.]+\.([A-Za-z]+):.*:([0-9]+).*|\1 \2|" | sed -n '4p' | sed -E "s|(.*)|\1PRO|"
	;;
	ioread)
		read0=$(dstat -d 1 2 --noupdate --headers | sed -n '4p' | awk '{ printf "%s\n", $1 }' | sed -E 's/[ ]*//g')
		if [[ "$read0" == *"k"* ]]; then
			echo "${read0}b/s"
		elif [[ "$read0" == *"M"* ]]; then
			echo "${read0}b/s"
		elif [[ "$read0" == *"G"* ]]; then
			echo "${read0}b/s"
		else
			echo "Reads"
		fi
	;;
	iowrite)
		write0=$(dstat -d 1 2 --noupdate --headers | sed -n '4p' | awk '{ printf "%s\n", $2 }' | sed -E 's/[ ]*//g')
		if [[ "$write0" == *"k"* ]]; then
			echo "${write0}b/s"
		elif [[ "$write0" == *"M"* ]]; then
			echo "${write0}b/s"
		elif [[ "$write0" == *"G"* ]]; then
			echo "${write0}b/s"
		else
			echo "Writes"
		fi
	;;
esac
