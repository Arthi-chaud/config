{ home }:
{ ... }:
if home then
  {
    home.file."clear-empty-spaces.sh" = {
      target = ".config/scripts/clear-empty-spaces.sh";
      source = ./clear-empty-spaces.sh;
      executable = true;
    };
  }
else
  let
    padding = 10;
  in
  {
    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
      config = {
        mouse_follows_focus = "on";
        layout = "bsp";
        focus_follows_mouse = "autofocus";
        window_border = "off";
        external_bar = "all:35:0";
        window_gap = padding;
        top_padding = padding;
        bottom_padding = padding;
        left_padding = padding;
        right_padding = padding;
        # NOTE: does not work, had to set it up manually
        # window_shadow = "off";
      };
      # TODO nixify 'clear-empty-spaces' script
      extraConfig = ''
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa

        yabai -m rule --add app="^(K|k)itty$" opacity=0.97
        yabai -m rule --add app='qemu-system-aarch64' manage=off

        # Clean up empty spaces with no windows on them.
        yabai -m signal --add event=space_changed action="sh ~/.config/scripts/clear-empty-spaces.sh"
        # Refocus on window destruction
        for event in "window_destroyed" "application_terminated" "window_hidden" "window_minimized" "application_hidden";
        do
        yabai -m signal --add event="$event" action="yabai -m query --windows --window &> /dev/null || yabai -m window --focus mouse"
        done

        sleep 5 ; yabai -m config window_shadow off
      '';
    };

  }
