#!/bin/sh
while true; do
    if ping -c 1 -W 2 8.8.8.8 > /dev/null 2>&1; then
        echo "Internet is working!"
        break
    fi
    sleep 3
done

spotify
