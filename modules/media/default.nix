{
  pkgs,
  isDarwin,
  lib,
  ...
}:

{
  home.packages = (
    with pkgs;
    [
      ffmpeg
      atomicparsley
      yt-dlp
    ]
  );
}
