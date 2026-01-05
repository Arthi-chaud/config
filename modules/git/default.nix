{ pkgs, isDarwin, ... }:
{
  config = {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      pinentry.package = if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-all;
    };
    programs.git = {
      enable = true;
      ignores = [
        ".envrc"
        ".DS_Store"
        ".direnv"
      ];
      settings = {
        user = {
          name = "Arthur Jamet";
          email = "arthur.jamet@gmail.com";
        };
        push = {
          autoSetupRemote = true;
        };
        signing = {
          signByDefault = true;
        };
        commit.gpgsign = true;
        pull.rebase = true;
        init.defaultBranch = "main";
        diff = {
          algorithm = "histogram";
        };
      };
    };
  };

}
