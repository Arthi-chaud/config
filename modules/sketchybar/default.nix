{ config, impurity, ... }:
let
  sketchybarDir = "${config.xdg.configHome}/sketchybar";
in
{
  home.file."${sketchybarDir}/items" = {
    source = impurity.link ./items;
    recursive = true;
  };

  home.file."${sketchybarDir}/plugins" = {
    source = impurity.link ./plugins;
    recursive = true;
  };
  programs.sketchybar = {
    enable = true;
    service.enable = true;
    # TODO Install font + nixify the launchtctl unload thing
    # TODO Use impurity here
    config = ''
      PLUGIN_DIR="${sketchybarDir}/plugins"
      FONT="SF Pro"
      # Unload the macOS on screen indicator overlay for volume change
      # Source: https://github.com/FelixKratz/dotfiles/blob/494db4c7f90b3de2ad3e8bf4aefa523fbfc8e071/.config/sketchybar/sketchybarrc#LL18C1-L18C65
      launchctl unload -F /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist > /dev/null 2>&1 &

      ##### Custom Events #####

      sketchybar --add event resize_toggle

      ##### Bar Appearance #####

      bar=(
        height=30
        margin=10
        y_offset=7	 
        blur_radius=15   
        corner_radius=7
        position=top     
        sticky=off       
        padding_left=10  
        padding_right=10 
        color=0x66282A2E
      )

      sketchybar --bar "''${bar[@]}"

      ##### Changing Defaults #####

      defaults=(
        icon.font="$FONT:Bold:16.0"  
        icon.color=0xffffffff                 
        label.font="$FONT:Semibold:14" 
        label.color=0xffffffff                
        padding_left=5                        
        padding_right=5                       
        label.padding_left=4                  
        label.padding_right=4                 
        icon.padding_left=4                   
        icon.padding_right=5 
        popup.background.border_width=2 
        popup.background.corner_radius=9 
        popup.background.border_color=0x66282A2 
        popup.background.color=0x66282A2         
        popup.blur_radius=20 
        popup.background.shadow.drawing=on
      )

      sketchybar --default "''${defaults[@]}"

      ##### Adding Mission Control Space Indicators #####
      # Now we add some mission control spaces:
      # https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item
      # to indicate active and available mission control spaces

      for i in $(seq -s " " 1 9 |xargs) 
      do
        sid=$i
        sketchybar --add space space.$sid left                                 \
                   --set space.$sid associated_space=$sid                      \
                      icon.drawing=on                           \
                      label.drawing=off                         \
                      drawing=off                      \
                      script="$PLUGIN_DIR/space.sh"              \
                      click_script="yabai -m space --focus $sid" \
                   --subscribe space.$sid space_change display_change
      done

      ##### Adding Items #####

      ITEM_DIR="$CONFIG_DIR/items"

      # Left
      source "$ITEM_DIR"/spaces.sh
      source "$ITEM_DIR"/front_app.sh

      # Right
      source "$ITEM_DIR"/clock.sh
      source "$ITEM_DIR"/wifi.sh
      source "$ITEM_DIR"/volume.sh
      source "$ITEM_DIR"/battery.sh

      ##### Finalizing Setup #####

      sketchybar --update
    '';
  };
}
