#!/bin/sh

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')


if [ $PERCENTAGE = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  9[0-9]|100) ICON="􀛨"
  ;;
  [6-8][0-9]) ICON="􀺸"
  ;;
  [3-5][0-9]) ICON="􀺶"
  ;;
  [1-2][0-9]) ICON="􀛩"
  ;;
  *) ICON="􀛪"
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="􀢋"
  sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%"
else
  sketchybar --set $NAME icon="$ICON" label="" label.padding_right=0 label.padding_left=0
fi

popup () {
  sketchybar --set battery.anchor popup.drawing=$1
}

update () {
  args=()
  # Disabling popup when charging
  if [[ $CHARGING == "" ]]; then
    args+=(
      --set battery.popup label="$PERCENTAGE%"
    )
  fi
  sketchybar -m "${args[@]}"
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "mouse.entered") popup on
  ;;
  "mouse.exited"|"mouse.exited.global") popup off
  ;;
  "forced") exit 0
  ;;
  *) update
  ;;
esac
