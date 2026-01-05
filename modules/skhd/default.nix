{ config, impurity, ... }:
let
  skhdDir = "${config.xdg.configHome}/skhd";
in
{

  home.file."${skhdDir}/open-browser.scpt".source = impurity.link ./open-browser.scpt;
  home.file."${skhdDir}/clear-notifications.scpt".source = impurity.link ./clear-notifications.scpt;
  home.file."${skhdDir}/move-window.sh".source = impurity.link ./move-window.sh;

  services.skhd = {
    enable = true;
    config = ''
      alt - return : open -na $(which kitty) --args --single-instance --instance-group kk -d ~

      alt - 0x0A : osascript ${skhdDir}/open-browser.scpt

      cmd - l : osascript ${skhdDir}/clear-notifications.scpt ; 

      alt - r : skhd --reload ; yabai --restart-service ; sketchybar --reload

      alt - f : yabai -m window --toggle native-fullscreen

      # Close Window
      cmd - q [
      	## But Keep Instance Open
      	"Finder": yabai -m window --close
      	"kitty": yabai -m window --close
      	"Discord": yabai -m window --close
      	"code": yabai -m window --close
      	"safari": yabai -m window --close
      	"Firefox": yabai -m window --close
      	"Microsoft Teams (work or school)": yabai -m window --close
      	* ~
      ]

      # Resize
      shift + alt - h : yabai -m window --resize left:-60:0 || yabai -m window --resize right:-60:0
      shift + alt - l : yabai -m window --resize right:60:0 || yabai -m window --resize left:60:0
      shift + alt - j : yabai -m window --resize bottom:0:60 || yabai -m window --resize top:0:60
      shift + alt - k : yabai -m window --resize top:0:-60 || yabai -m window --resize bottom:0:-60

      # Focus Space
      alt - 1: yabai -m space --focus 1
      alt - 2: yabai -m space --focus 2
      alt - 3: yabai -m space --focus 3
      alt - 4: yabai -m space --focus 4
      alt - 5: yabai -m space --focus 5
      alt - 6: yabai -m space --focus 6
      alt - 7: yabai -m space --focus 7
      alt - 8: yabai -m space --focus 8
      alt - 9: yabai -m space --focus 9

      # create space, move window and follow focus
      shift + alt - n : yabai -m space --create && \
          index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')" && \
      	yabai -m window --space $index && \
          yabai -m space --focus $index

      # Create space, without window
      alt - n : yabai -m space --create && \
          index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')" && \
          yabai -m space --focus $index

      shift + alt - 1: index=1 ; yabai -m window --space $index && yabai -m space --focus $index
      shift + alt - 2: index=2 ; yabai -m window --space $index && yabai -m space --focus $index
      shift + alt - 3: index=3 ; yabai -m window --space $index && yabai -m space --focus $index
      shift + alt - 4: index=4 ; yabai -m window --space $index && yabai -m space --focus $index
      shift + alt - 5: index=5 ; yabai -m window --space $index && yabai -m space --focus $index
      shift + alt - 6: index=6 ; yabai -m window --space $index && yabai -m space --focus $index
      shift + alt - 7: index=7 ; yabai -m window --space $index && yabai -m space --focus $index
      shift + alt - 8: index=8 ; yabai -m window --space $index && yabai -m space --focus $index
      shift + alt - 9: index=9 ; yabai -m window --space $index && yabai -m space --focus $index

      # Focus Window
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - h : yabai -m window --focus west
      alt - l : yabai -m window --focus east

      # Swap Window
      cmd + alt - h : ${skhdDir}/move-window.sh west
      cmd + alt - l : ${skhdDir}/move-window.sh east
      cmd + alt - k : ${skhdDir}/move-window.sh north
      cmd + alt - j :  ${skhdDir}/move-window.sh south

      # Focus Display
      alt - down : yabai -m display --focus south
      alt - up : yabai -m display --focus north
      alt - left : yabai -m display --focus west
      alt - right : yabai -m display --focus east

      # Move Window to Display
      cmd + alt - left : ${skhdDir}/move-window.sh west display
      cmd + alt - right : ${skhdDir}/move-window.sh east display
      cmd + alt - up : ${skhdDir}/move-window.sh north display
      cmd + alt - down :  ${skhdDir}/move-window.sh south display
    '';
  };
}
