#!/bin/sh

# Skin folder
SKIN_DIR="$HOME/.config/qmmp/skins"
CONFIG_FILE="$HOME/.config/qmmp/qmmp.conf"
CACHE_DIR="$HOME/.cache/qmmp/skinned"
CURRENT_SKIN=$(cat $CONFIG_FILE | grep "skin_path=" | sed -E 's/^skin_path=(.*)$/\1/')

# Pick random skin
RANDOM_SKIN=$(find "$SKIN_DIR" \( -type f -name "*.wsz" -o -type d \) | shuf -n 1)
while [[ $RANDOM_SKIN == $CURRENT_SKIN ]]; do
	RANDOM_SKIN=$(find "$SKIN_DIR" \( -type f -name "*.wsz" -o -type d \) | shuf -n 1)
done

# Update the config file
sed -i "/^skin_path=/c\skin_path=$RANDOM_SKIN" "$CONFIG_FILE"

# Clear cache
rm -rf "$CACHE_DIR"

qmmp ~/music/$(date +%F)/
