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
      haskell.compiler.ghc98
      haskellPackages.cabal-install
      fourmolu
      hlint
      (haskell-language-server.override { supportedGhcVersions = [ "98" ]; })

      zlib
      pkg-config
      bun
      python313

      docker
      docker-compose
      docker-buildx

      yaml-language-server

      # Java (for android dev)
      zulu17

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
