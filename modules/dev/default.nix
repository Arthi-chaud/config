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
      # Haskell
      haskell.compiler.ghc912
      (haskell-language-server.override { supportedGhcVersions = [ "912" ]; })
      haskellPackages.hlint
      haskellPackages.fourmolu
      haskellPackages.stack

      gcc
      bun
      python313

      docker
      docker-compose

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
