{ ... }:
{
  config = {
    programs.gpg.enable = true;
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
