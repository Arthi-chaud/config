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
      nestor = (import ./hosts/nestor.nix) inputs;
    in
    macbook // nestor;
}
