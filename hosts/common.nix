{
  secrets = (import "${builtins.getEnv "PWD"}/secrets/default.nix");
  nixGc = {
    nix.gc = {
      # TODO Look more into features and doc
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
  nixSettings = {
    nix.settings = {
      experimental-features = "nix-command flakes";
      warn-dirty = false;
    };
    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];
  };
}
