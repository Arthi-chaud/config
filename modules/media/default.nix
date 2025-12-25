{
  pkgs,
  isDarwin,
  lib,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      ffmpeg
      atomicparsley
      yt-dlp
    ]
    ++ lib.optional (!isDarwin) [ makemkv ];
}
