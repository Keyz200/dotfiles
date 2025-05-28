#!/bin/sh
MAX_IMAGES=4
FILE=/tmp/.current_image
if [ ! -e $FILE ]; then
	echo 1 > $FILE
fi

CURRENT_IMAGE=$(cat $FILE)

if [[ $CURRENT_IMAGE == $MAX_IMAGES ]]; then
	echo 1 > $FILE
else
	echo $((CURRENT_IMAGE+1)) > $FILE
fi

echo "$HOME/images/waybar/image$(cat $FILE).png"
