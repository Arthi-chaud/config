{ config, impurity, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # NOTE: Silences warning after bumping to nixpkgs 26
    withRuby = false;
    withPython3 = false;
    # NOTE: When false, it creates a defulat init.lua which clashes with our config.
    # Disabling that
    sideloadInitLua = true;
  };
  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  home.file."${config.xdg.configHome}/nvim" = {
    source = impurity.link ./.;
    recursive = true;
  };
}
