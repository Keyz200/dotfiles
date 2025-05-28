#!/bin/sh
param="$1"

case $param in
	load)
		gpuutil=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
		echo "$gpuutil"
	;;
	temp)
		gputemp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
		echo "$gputemp"
	;;
	usedmem)
		gpuusedmem=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
		echo "$gpuusedmem"
	;;
	totalmem)
		gputotalmem=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
		echo "$gputotalmem"
	;;
	prwdraw)
		gpuprwdraw=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | sed -E "s|(.*)\.(.*)|\1W|")
		echo "$gpuprwdraw"
	;;
	currentclock)
		gpucurrentclock=$(nvidia-smi --query-gpu=clocks.current.graphics --format=csv,noheader,nounits)
		echo "$gpucurrentclock"
	;;
	maxclock)
		gpumaxclock=$(nvidia-smi --query-gpu=clocks.max.graphics --format=csv,noheader,nounits)
		echo "$gpumaxclock"
	;;
	currentmemclock)
		gpucurrentmemclock=$(nvidia-smi --query-gpu=clocks.current.memory --format=csv,noheader,nounits)
		echo "$gpucurrentmemclock"
	;;
	maxmemclock)
		gpumaxmemclock=$(nvidia-smi --query-gpu=clocks.max.memory --format=csv,noheader,nounits)
		echo "$gpumaxmemclock"
	;;
	name)
		lspci | grep -i "vga\|3d\|display" | sed -E 's|.*\[(.*)|\1|' | awk '{printf "%s %s %s\n", $2, $3, $4}' | sed -E 's|(.*)\]|\1|'
	;;
esac
