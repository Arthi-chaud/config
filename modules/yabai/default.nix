{ home }:
{
  impurity,
  pkgs,
  config,
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
  let
    yabai =

      (
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
  in
  {

    environment.systemPackages = [ yabai ];

    # Rest is copied from nixpgs

    launchd.daemons.yabai-sa = {
      command = "${yabai}/bin/yabai --load-sa";
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = {
          SuccessfulExit = false;
          Crashed = true;
        };
        Nice = -20;
        StandardErrorPath = "/tmp/yabai-sa.err.log";
      };
    };

    launchd.user.agents.yabai = {
      command = "${yabai}/bin/yabai";
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = {
          SuccessfulExit = false;
          Crashed = true;
        };
        Nice = -20;
        StandardOutPath = "/tmp/yabai.out.log";
        StandardErrorPath = "/tmp/yabai.err.log";
        ProcessType = "Interactive";
        EnvironmentVariables = {
          PATH = "${yabai}/bin:${config.environment.systemPath}";
        };
      };
    };

    environment.etc."sudoers.d/yabai".source = pkgs.runCommand "sudoers-yabai" { } ''
      YABAI_BIN="${yabai}/bin/yabai"
      SHASUM=$(sha256sum "$YABAI_BIN" | cut -d' ' -f1)
      cat <<EOF >"$out"
      %admin ALL=(root) NOPASSWD: sha256:$SHASUM $YABAI_BIN --load-sa
      EOF
    '';

  }
