{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ocaml
    dune_3
    ocamlPackages.ocaml-lsp
    ocamlPackages.core
    ocamlPackages.utop
    ocamlPackages.yojson
    ocamlPackages.yaml
    ocamlPackages.menhir
  ];
}
