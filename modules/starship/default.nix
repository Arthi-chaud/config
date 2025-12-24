{
  config,
  impurity,
  isServer,
  hostname,
  lib,
  ...
}:

{
  programs.starship = {
    enable = true;
  };
  home.file."${config.xdg.configHome}/starship.toml".source =
    if (!isServer) then
      impurity.link ./starship.toml
    # TODO Test
    else
      lib.mkMerge [
        ./starship.toml
        ''
          [hostname]
          ssh_only = false
          ssh_symbol = ""
          format = '[\[${hostname}}\]]($style) '
        ''
      ];
}
