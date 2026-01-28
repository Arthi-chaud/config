{
  config,
  secrets,
  isDarwin,
  isServer,
  lib,
  profileName,
  useStandaloneHM,
  ...
}:
let
  zshDir = "${config.xdg.configHome}/zsh";
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = zshDir;
    sessionVariables = {
      DEVELOPER_DIR = ""; # https://github.com/NixOS/nixpkgs/issues/376958
      # TODO Remove me
      ANDROID_HOME = "$HOME/Library/Android/sdk";
      PATH = "$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$HOME/.local/bin/:/nix/var/nix/profiles/default/bin";

      # NOTE: Oh My Zsh-specific, can help speeding up at start
      DISABLE_AUTO_UPDATE = "true";
      DISABLE_MAGIC_FUNCTIONS = "true";
      DISABLE_COMPFIX = "true";
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = "20";
    }
    // lib.optionalAttrs isServer { TERM = "xterm-256color"; };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker-compose"
        "docker"
        "stack"
        "yarn"
      ];
      theme = "robbyrussell";
    };
    history = {
      append = true;
      save = 10000;
      size = 10000;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      findNoDups = true;
      expireDuplicatesFirst = true;
    };
    shellAliases = {
      "n" = "nvim";
      "m" = "make";
      "ssh-nestor" = "ssh ${secrets.sshNestor}";
      "ffj" = "ffprobe -v quiet -print_format json -show_format -show_streams";

      "rb" =
        if isDarwin then
          "sudo IMPURITY_PATH=\"$(pwd)\" darwin-rebuild switch --impure --flake .#${profileName}"
        else if useStandaloneHM then
          "IMPURITY_PATH=\"$(pwd)\" nix run home-manager/master -- switch --flake .#${profileName} --impure"
        else
          throw "Don't know what the 'rb' alias should look like";

      "cs" = "sudo nix-collect-garbage -d";

      "bi" = "brew install";
      "bU" = "brew uninstall";
      "bu" = "brew upgrade";
      "bs" = "brew search";

      "st" = "stack test";
      "sb" = "stack build";
      "sc" = "stack clean";
      "shaddock" = "stack haddock . --no-haddock-deps";
      "sghci" = "stack ghci";
      "sbench" = "stack bench";

      "cb" = "cabal build";
      "cr" = "cabal repl";

      "ga" = "git add";
      "gs" = "git status";
      "gl" = "git log";
      "gsth" = "git stash";
      "gc" = "git commit -m ";
      "gca" = "git commit --amend";
      "gcan" = "git commit --amend --no-edit";

      "dcd" = "docker compose -f docker-compose.dev.y*ml";
      "dcdu" = "dcd up";
      "dcde" = "dcd exec -it";
      "dcdud" = "dcd up -d";
      "dcdd" = "dcd down";
      "dcdl" = "dcd logs";
      "dcdlf" = "dcd logs -f";

      "yt" =
        "yt-dlp --merge-output-format mp4 -S 'vcodec:h264' -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best'";
    };
    completionInit = ''
      autoload -Uz compinit
      if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
          compinit
      else
          compinit -C
      fi
    '';
    initContent = ''
      # source: https://github.com/zoriya/flake/blob/master/modules/cli/zsh/init.zsh#L42
      nixify() {
          if [ ! -e ./.envrc ]; then
              echo "use nix" > .envrc
          fi
          if [[ ! -e shell.nix ]]; then
              cat > shell.nix <<'EOF'
      {pkgs ? import <nixpkgs> {}}:
      pkgs.mkShell {
        packages = with pkgs; [
          
        ];
      }
      EOF
          fi
          direnv allow
      }
      # TODO Delete me
      #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
      export SDKMAN_DIR="$HOME/.sdkman"
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
    '';
  };
  home.sessionPath = [
    "$HOME/.ghcup/bin"
    "$HOME/.cabal/bin"
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  # Source: https://github.com/direnv/direnv/issues/68#issuecomment-2054033048
  # and https://github.com/direnv/direnv/issues/203#issuecomment-3061299852
  # To avoid an overflow of logs
  home.file.".config/direnv/direnv.toml".text = ''
    [global]
    hide_env_diff = true
    log_filter="^loading"
  '';
}
