{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ocaml
    opam # TEMP
    dune_3
    # ocamlPackages.ocaml-lsp
    # ocamlPackages.core
    # ocamlPackages.utop
    # ocamlPackages.yojson
    # ocamlPackages.yaml
    # ocamlPackages.menhir
    # ocamlPackages.ocamlformat
    # ocamlPackages.ppx_compare
    # ocamlPackages.ppx_deriving
    # ocamlPackages.ppx_jane
  ];
}
