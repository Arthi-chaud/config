{
  pkgs,
  lib,
  isDarwin,
  isServer,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      curl
      less
      openssl
      bat
      viu
      jq
      p7zip
      htop
    ]
    ++ lib.optionals isDarwin [ pinentry-tty ]
    ++ lib.optionals (!isServer) [ mpv ];
}
