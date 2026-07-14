{ home }:
{
  impurity,
  pkgs,
  ...
}:
if home then
  {
    home.file."clear-empty-spaces.sh" = {
      target = ".config/scripts/clear-empty-spaces.sh";
      source = ./clear-empty-spaces.sh;
      executable = true;
    };
    home.file.".config/yabai/yabairc" = {
      source = impurity.link ./yabairc;
    };
  }
else
  {
    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
      # NOTE: We use the precompile binary. The one built by nix does not work with SA
      package = (
        pkgs.stdenv.mkDerivation rec {
          pname = "yabai";
          version = "7.1.25";

          src = pkgs.fetchurl {
            url = "https://github.com/asmvik/${pname}/releases/download/v${version}/${pname}-v${version}.tar.gz";
            hash = "sha256-dvODhBVwv+Hj/STO3ZsaS4BLQ7DznIapUcl9GH/GsbQ=";
          };
          unpackPhase = ''
            tar -xzf $src
          '';

          installPhase = ''
            install -Dm755 archive/bin/yabai $out/bin/yabai
          '';

        }
      );
    };
  }
