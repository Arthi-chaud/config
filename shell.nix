{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    nixfmt
    stylua
    lua-language-server
    nixd
  ];

}
