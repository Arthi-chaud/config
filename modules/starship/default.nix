{ config, impurity, ... }:

{
  # TODO Migrate server's prompt as well
  programs.starship = {
    enable = true;
  };
  home.file."${config.xdg.configHome}/starship.toml".source = impurity.link ./starship.toml;
}
