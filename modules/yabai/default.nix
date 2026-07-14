{ home }:
{ impurity, ... }:
if home then
  {
    home.file."clear-empty-spaces.sh" = {
      target = ".config/scripts/clear-empty-spaces.sh";
      source = ./clear-empty-spaces.sh;
      executable = true;
    };
    home.file.".config/yabai/yabairc" = {
      source = impurity.link ./yabairc;
    };
  }
else
  {
    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
    };

  }
