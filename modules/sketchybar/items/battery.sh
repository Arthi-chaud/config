#!/bin/bash

POPUP_SCRIPT="sketchybar -m --set battery.anchor popup.drawing=toggle"

battery_anchor=(
  script="$PLUGIN_DIR/battery.sh"
  click_script="$POPUP_SCRIPT"
  label.drawing=off
  update_freq=120
  updates=on
  popup.horizontal=on
  popup.align=center
  popup.height=20
)

battery_popup=(
  script="$PLUGIN_DIR/battery.sh"
  label.drawing=on
  icon.drawing=off
  padding_left=10
  padding_right=10
)

sketchybar --add item battery.anchor right		\
    --set battery.anchor "${battery_anchor[@]}"		\
    --subscribe battery.anchor power_source_change system_woke \
    --subscribe battery.anchor mouse.entered mouse.exited mouse.exited.global \
      \
    --add item battery.popup popup.battery.anchor         \
    --set battery.popup "${battery_popup[@]}"