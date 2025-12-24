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
    {
      self,
      home-manager,
      nix-darwin,
      nix-homebrew,
      impurity,
      ...
    }:

    let
      # NOTE: Hideous
      secrets = (import "${builtins.getEnv "PWD"}/secrets/default.nix");
      brew = {
        nix-homebrew = {
          enable = true;
          user = "arthur";
          autoMigrate = true;
        };
        homebrew = {
          enable = true;
          casks = [
            "android-file-transfer"
            "makemkv"
            "alfred"
            "sf-symbols"
          ];
          onActivation.cleanup = "zap";
        };
      };
      home =
        { impurity, ... }:
        {
          home-manager = {
            extraSpecialArgs = {
              inherit impurity;
              inherit secrets;
            };
            useGlobalPkgs = true;
            useUserPackages = true;
            users.arthur = {
              home.homeDirectory = "/Users/arthur";
              home.username = "arthur";
              home.stateVersion = "25.11";

              imports = [
                ./modules/gui
                ./modules/nvim
                ./modules/kitty
                ./modules/sketchybar
                ./modules/skhd
                ./modules/zsh
                ./modules/starship
                ./modules/yabai/home.nix
                ./modules/media
                ./modules/dev
                ./modules/git
              ];
            };
          };
        };
      configuration =
        { pkgs, ... }:
        {
          nix.settings.experimental-features = "nix-command flakes";
          nix.enable = false;
          nixpkgs.config.allowUnfree = true;
          environment.systemPackages = with pkgs; [
            curl
            openssl
            mpv
            bat
            viu
            jq
            less
            p7zip
            htop
            pinentry-tty
          ];
          programs.gnupg.agent = {
            enable = true;
          };

          # TODO hide 'tree is dirty'
          # TODO gc

          # darwin
          system.primaryUser = "arthur";
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

          users.users.arthur = {
            home = "/Users/arthur";
            shell = pkgs.zsh;
          };

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      darwinConfigurations.macbook =
        (nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            {
              imports = [ impurity.nixosModules.impurity ];
              impurity.configRoot = self;
            }
            configuration
            home-manager.darwinModules.home-manager
            home
            nix-homebrew.darwinModules.nix-homebrew
            brew
            ./modules/yabai
          ];
        }).extendModules
          { modules = [ { impurity.enable = true; } ]; };
    };
}
