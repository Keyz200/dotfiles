#!/bin/sh
time=$(date +%H)
firstnumber=$(echo "$time" | sed -E "s|(^[0-9]).*|\1|")

if [[ "$firstnumber" == "0" ]]; then
	time=$(echo "$time" | sed -E "s|^[0-9](.*)|\1|")
fi

if [[ "$time" -ge 6 && "$time" -lt 18 ]]; then
	echo "󰖨"
else
	echo ""
fi
