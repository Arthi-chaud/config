{ config, impurity, ... }:
{
  programs.neovim = {
    enable = true;
  };
  programs.fd.enable = true;
  programs.ripgrep.enable = true;
  home.file."${config.xdg.configHome}/nvim" = {
    source = impurity.link ./.;
    recursive = true;
  };
}
