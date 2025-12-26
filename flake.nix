{
  description = "Flake for an artichoke";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    impurity.url = "github:outfoxxed/impurity.nix";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      mkSystem = import ./lib/mkSystem.nix inputs;
    in
    {
    
      homeConfigurations.arthichaud = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
	    extraSpecialArgs = { isDarwin = false; profileName = "nestor"; };
	    modules = [ ./modules/media ./modules/dev {
	    home = {
          username = "arthichaud";
          homeDirectory = "/home/arthichaud";
        };
            home.stateVersion = "25.11";

	    } ];


    	};
      darwinConfigurations.macbook = mkSystem "macbook" {
        username = "arthur";
        system = "aarch64-darwin";
        additionalHome = [
          ./modules/sketchybar
          ./modules/skhd
          ./modules/yabai/home.nix
        ];
        additionalModules = [
          ./modules/yabai
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
          inputs.nix-homebrew.darwinModules.nix-homebrew
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
          { system.stateVersion = 6; }
        ];
      };
    };
}
