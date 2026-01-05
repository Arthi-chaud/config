{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode
    bitwarden-desktop
    obsidian # TODO nixify config
    insomnia
    qbittorrent
    zotero
    google-chrome
    firefox
  ];
}
