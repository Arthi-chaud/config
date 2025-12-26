{
  config,
  impurity,
  ...
}:

{
  programs.starship = {
    enable = true;
  };
  home.file."${config.xdg.configHome}/starship.toml".source = impurity.link ./starship.toml;
}
