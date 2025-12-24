#!/bin/sh

# The wifi_change event supplies a $INFO variable in which the current SSID
# is passed to the script.

# From
# https://stackoverflow.com/questions/78994709/how-to-get-the-current-wi-fi-ssid-in-swift-on-macos

sketchybar --set $NAME label="Loading..." icon=􀤆
INFO="$(system_profiler SPAirPortDataType | awk '/Current Network/ {getline;$1=$1;print $0 | "tr -d ':'";exit}')"

INTERFACE="$( route get default 2>&1 | grep interface | awk '{print $2}')"
INTERFACE=${INTERFACE:-"x"}
HARDWARE_TYPE="$(networksetup -listnetworkserviceorder | grep -B 1 "Device: $INTERFACE" | head -n 1 | awk '{print $2}')"


NOT_CONNECTED="Not Connected"
LABEL=${INFO:-"$NOT_CONNECTED"}
ICON=􀙇

if [[ $INFO == *"Wi-Fi power is currently off"* ]]; then
	LABEL="$NOT_CONNECTED"
fi

if [[ $INFO == "You are not associated"* ]]; then
	LABEL="$NOT_CONNECTED"
fi

if [[ "$LABEL" == "$NOT_CONNECTED" ]]; then
	ICON=􀙈
fi

if [[ $HARDWARE_TYPE == "USB" ]]; then 
	LABEL="Ethernet"
	ICON=􀺦
fi

# if [ "$SENDER" = "wifi_change" ]; then 
# 	LABEL=${INFO:-"$NOT_CONNECTED"}
#
# 	if [[ "$LABEL" = "$NOT_CONNECTED" ]]; then 
# 		ICON=􀙈
# 	fi
# fi

sketchybar --set $NAME label="${LABEL}" icon=$ICON
