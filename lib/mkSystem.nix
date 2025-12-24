inputs@{
  self,
  nixpkgs,
  ...
}:
profileName:
{
  hostname ? profileName,
  username,
  system,
  isServer ? false,
  additionalModules ? [ ],
  additionalHome ? [ ],
}:
let
  # NOTE: Hideous
  secrets = (import "${builtins.getEnv "PWD"}/secrets/default.nix");
  newSystemFunc = if isDarwin then inputs.nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  isDarwin = nixpkgs.lib.strings.hasSuffix "-darwin" system;
  homeManager =
    if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
  homeDir = if isDarwin then "/Users/${username}" else "/home/${username}";
  specialArgs = {
    inherit
      profileName
      hostname
      username
      isDarwin
      isServer
      system
      ;
  };
in
(newSystemFunc {
  inherit system specialArgs;
  modules = [
    {
      imports = [ inputs.impurity.nixosModules.impurity ];
      impurity.configRoot = self;
    }
    (
      { pkgs, ... }:
      {
        users.users.${username} = {
          home = homeDir;
          shell = pkgs.zsh;
          isNormalUser = true;
        };
        environment.systemPackages =
          with pkgs;
          [
            curl
            less
            openssl
            bat
            viu
            jq
            p7zip
            htop
          ]
          ++ nixpkgs.lib.optionals isDarwin [ pinentry-tty ]
          ++ nixpkgs.lib.optionals (!isServer) [ mpv ];
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
    homeManager.home-manager
    (
      { lib, impurity, ... }:
      {
        home-manager = {
          extraSpecialArgs = specialArgs // {
            inherit impurity;
            inherit secrets;
          };
          useGlobalPkgs = true;
          useUserPackages = true;
		  home.homeDirectory = lib.mkForce homeDir;
	      home.username = username;
		  home.stateVersion = "25.11";

          users.${username} = {
            imports = [
              ../modules/nvim
              ../modules/zsh
              ../modules/starship
              ../modules/media
              ../modules/dev
              ../modules/git
            ]
            ++ nixpkgs.lib.optionals (!isServer) [
              ../modules/gui
              ../modules/kitty
            ]
            ++ additionalHome;
          };
        };
      }
    )
    {
      nixpkgs.hostPlatform = system;
      nixpkgs.config.allowUnfree = true;

      nix.enable = !isDarwin; # TODO Installed nix using determinate on macos
      nix.settings = {
        experimental-features = "nix-command flakes";
        warn-dirty = false;
      };
    }
  ]
  ++ nixpkgs.lib.optionals (!isDarwin) [
    {
      # TODO Remove condition once macbook has nix w/o determinate
      nix.gc = {
        # TODO Look more into features and doc
        automatic = true;
        options = "--delete-older-than 30d";
      };
    }
  ]
  ++ nixpkgs.lib.optionals isDarwin [
    {
      system.primaryUser = username;
    }
  ]
  ++ additionalModules;
}).extendModules
  { modules = [ { impurity.enable = true; } ]; }
