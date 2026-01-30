#!/bin/bash

direction="$1"
moveIsHorizontal=1
([ "$direction" =  "west" ] || [ "$direction" = "east" ] ) && moveIsHorizontal=0



yabai -m window --warp "$direction" --focus || yabai -m window --display "$direction" --focus || (
split="$(yabai -m query --windows --window | jq '."split-type"' -r )"
# If the movement does not follow the layout flow, toggle the flow and retry moving the window
if ([ "$split" = "vertical" ] &&  [  $moveIsHorizontal -ne 0 ] ) || ([ "$split" = "horizontal" ] &&  [ $moveIsHorizontal -eq 0 ]  ) ; then
  yabai -m window --toggle split
  yabai -m window --warp "$direction" --focus
fi
)

# NOTE: in some cases (eg. depending on the orientation of the screen, we might not want to move to display, just toggle)
