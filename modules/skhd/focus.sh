
direction="$1"
opDirection=""

case "$direction" in
    west)
     opDirection="east" 
    ;;
    east)
     opDirection="west" 
    ;;
    north)
     opDirection="south" 
    ;;
    south)
     opDirection="north" 
    ;;
esac

(yabai -m window --focus "$direction" || (yabai -m display --focus "$direction" && yabai -m window --focus "$opDirection")) 2> /dev/null 
