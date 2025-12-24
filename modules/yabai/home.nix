{ ... }:
{
  home.file."clear-empty-spaces.sh" = {
    target = ".config/scripts/clear-empty-spaces.sh";
    source = ./clear-empty-spaces.sh;
    executable = true;
  };
}
