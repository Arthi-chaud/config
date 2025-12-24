#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item


if [ "$SELECTED" = "true" ]; then
  sketchybar -m --set $NAME icon=􀀁 drawing=true
else
  sketchybar -m --set $NAME icon=􀀀 drawing=true
  # if [ "$(yabai -m query --spaces --space "${NAME/space./}" | jq '."is-native-fullscreen" == false and ."windows" == [] and ."has-focus" == false')" = "true" ];
  # then
  #   sketchybar -m --set $NAME drawing=false
  # fi
fi
