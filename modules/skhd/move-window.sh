#!/bin/bash

direction="$1"

target="$2" # 'space' or 'display'

if [ -z "$target" ] || [ "$target" = "space" ]; then 
	yabai -m window --warp "$direction" || yabai -m window --toggle split ; yabai -m window --warp "$direction"
else
	yabai -m window --swap "$direction" || yabai -m window --display "$direction"; yabai -m display --focus "$direction"
fi
