{ pkgs, ... }:
{
  home.packages = with pkgs; [
    idris
    idris2
    idris2Packages.idris2Lsp
  ];
}

