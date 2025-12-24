sketchybar --add item volume right                             \
           --set volume  script="$PLUGIN_DIR/volume.sh"        \
           label.padding_left=0 label.padding_right=0          \
           --subscribe volume volume_change
