# Tree-sitter grammars for Emacs, provisioned declaratively.
#
# Linked to $XDG_DATA_HOME/emacs/tree-sitter as libtree-sitter-<lang>.so
# (.dylib on Darwin), which ELispMachine/init.el adds to
# `treesit-extra-load-path'. The ts-modes are enabled only when that directory
# exists, so Emacs without these grammars (e.g. plain Termux) keeps the
# classic major modes.
#
# Only languages whose Emacs 30 ts-mode works with these grammars are listed:
# cmake-ts-mode, for instance, fails with a query error. javascript needs jsdoc
# as js-ts-mode embeds it for doc comments.
{ pkgs, ... }:

let
  grammars = pkgs.emacsPackages.treesit-grammars.with-grammars (
    p: with p; [
      tree-sitter-bash
      tree-sitter-c
      tree-sitter-c-sharp
      tree-sitter-cpp
      tree-sitter-css
      tree-sitter-javascript
      tree-sitter-jsdoc
      tree-sitter-json
      tree-sitter-python
      tree-sitter-rust
      tree-sitter-toml
      tree-sitter-tsx
      tree-sitter-typescript
      tree-sitter-yaml
    ]
  );
in
{
  xdg.dataFile."emacs/tree-sitter".source = "${grammars}/lib";
}
