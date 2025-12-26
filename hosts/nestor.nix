{
  home-manager,
  nixpkgs,
  impurity,
  self,
  ...
}:
let
  system = "x86_64-linux";
  common = import ./common.nix;
  username = "arthichaud";
  isDarwin = false;
  profileName = "nestor";
  isServer = true;
  useStandaloneHM = true;
  specialArgs = {
    inherit
      username
      system
      isDarwin
      isServer
      profileName
      useStandaloneHM
      ;
  };
in
{
  homeConfigurations.${profileName} = home-manager.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    extraSpecialArgs = specialArgs // {
      secrets = common.secrets;
    };
    modules = [
      {
        imports = [ impurity.nixosModules.impurity ];
        impurity.configRoot = self;
        impurity.enable = true;
      }
      ../modules/base
      ../modules/media
      ../modules/dev
      ../modules/git
      ../modules/zsh
      ../modules/nvim
      ../modules/starship
      {
        home = {
          inherit username;
          homeDirectory = "/home/arthichaud";
          stateVersion = "25.11";
        };
      }
      common.nixSettings
      common.nixGc
      (
        { pkgs, ... }:
        {
          nix.package = pkgs.nix;
        }
      )
    ];

  };
}
