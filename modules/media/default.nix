{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # NOTE: Picard is not compatible with mac
    ffmpeg
    atomicparsley
    yt-dlp
  ];
}
