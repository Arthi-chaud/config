#!/usr/bin/env bash
# Source: https://github.com/koekeishiya/yabai/issues/213#issuecomment-1358715546
yabai -m query --spaces --display | \
     jq -re 'map(select(."is-native-fullscreen" == false)) | length > 1' \
     && yabai -m query --spaces | \
          jq -re 'map(select(."windows" == [] and ."has-focus" == false).index) | reverse | .[] ' | \
          xargs -I % sh -c 'yabai -m space % --destroy'
sketchybar --trigger space_change