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
    inputs:
    let
      macbook = (import ./hosts/macbook.nix) inputs;
    in
    macbook // { };

  # {

  # homeConfigurations.arthichaud = inputs.home-manager.lib.homeManagerConfiguration {
  #   pkgs = nixpkgs.legacyPackages.x86_64-linux;
  #   extraSpecialArgs = {
  #     isDarwin = false;
  #     profileName = "nestor";
  #   };
  #   modules = [
  #     ./modules/media
  #     ./modules/dev
  #     {
  #       home = {
  #         username = "arthichaud";
  #         homeDirectory = "/home/arthichaud";
  #       };
  #       home.stateVersion = "25.11";
  #     }
  #   ];
  #
  # };

}
