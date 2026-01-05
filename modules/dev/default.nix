{
  pkgs,
  lib,
  isDarwin,
  ...
}:

{
  home.packages =
    with pkgs;
    [
      # TODO Haskell
      zlib
      pkg-config
      bun
      python313

      docker
      docker-compose
      docker-buildx

      yaml-language-server

      # Nix
      nixfmt
      # Latex
      (texlive.combine {
        inherit (texlive)
          scheme-medium
          biblatex
          # from lipics template
          multirow
          threeparttable
          comment
          cleveref
          tikz-qtree
          import
          ;
      })
    ]
    ++ lib.optionals isDarwin [ colima ];
}
