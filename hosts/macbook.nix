{
  nix-homebrew,
  nix-darwin,
  home-manager,
  self,
  ...
}@inputs:
let
  common = import ./common.nix;
  username = "arthur";
  system = "aarch64-darwin";
  isDarwin = true;
  profileName = "macbook";
  isServer = false;
  specialArgs = {
    inherit
      username
      system
      isDarwin
      isServer
      profileName
      ;
  };
in
{
  darwinConfigurations.${profileName} = nix-darwin.lib.darwinSystem {
    inherit system specialArgs;
    modules = [
      (
        { pkgs, ... }:
        {
          users.users.${username} = {
            home = "/Users/${username}";
            shell = pkgs.zsh;
          };
          fonts.packages = with pkgs; [
            nerd-fonts.hack
            nerd-fonts.fira-code
          ];
          # TODO
          programs.gnupg.agent = {
            enable = true;
          };
        }
      )
      home-manager.darwinModules.home-manager
      (
        { impurity, ... }:
        {
          home-manager = {
            extraSpecialArgs = specialArgs // {
              inherit impurity;
              secrets = common.secrets;
            };
            useGlobalPkgs = true;
            useUserPackages = true;

            users.${username} = {
              home.stateVersion = "25.11";
              imports = [
                ../modules/base
                ../modules/nvim
                ../modules/zsh
                ../modules/starship
                ../modules/media
                ../modules/dev
                ../modules/git
                ../modules/sketchybar
                ../modules/skhd
                ../modules/yabai/home.nix
                ../modules/gui
                ../modules/kitty
              ];
            };
          };
        }
      )
      ../modules/yabai
      {
        # Darwin
        system.defaults = {
          dock = {
            orientation = "bottom";
            persistent-apps = [
              { app = "/System/Applications/Launchpad.app"; }
              { app = "/Applications/Safari.app"; }
            ];
            show-recents = false;
            autohide = true;
          };
          NSGlobalDomain = {
            AppleInterfaceStyleSwitchesAutomatically = true;
            AppleInterfaceStyle = null; # i.e. not Dark
          };
        };
      }
      nix-homebrew.darwinModules.nix-homebrew
      {
        # Homebrew
        nix-homebrew = {
          enable = true;
          user = "arthur";
          autoMigrate = true;
        };
        homebrew = {
          enable = true;
          onActivation.cleanup = "zap";
          casks = [
            "microsoft-teams"
            "android-file-transfer"
            "makemkv"
            "alfred"
            "sf-symbols"
          ];
        };
      }
      common.nixSettings
      # TODO add nixGc when got rid of determinate
      {
        nix.enable = !isDarwin; # TODO Installed nix using determinate on macos

        nixpkgs.hostPlatform = system;
        nixpkgs.config.allowUnfree = true;

        system.stateVersion = 6;
        system.primaryUser = username;
      }
      {
        imports = [ inputs.impurity.nixosModules.impurity ];
        impurity.configRoot = self;
        impurity.enable = true;
      }
    ];
  };
}
