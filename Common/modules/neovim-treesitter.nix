# Tree-sitter parsers for Neovim, provisioned declaratively.
#
# The nvim-treesitter plugin is kept only for its query corpus; parsers come
# from here rather than from :TSInstall, which writes into the data directory
# outside of Nix's control. NeovimConfig/init.lua appends
# $XDG_DATA_HOME/nvim/site to 'runtimepath' so these are discovered.
#
# Note that the grammars' own queries (upstream ships some under $out/queries)
# are deliberately not linked: their capture names target the tree-sitter CLI
# rather than Neovim, so nvim-treesitter's adapted queries are used instead.
{ pkgs, lib, ... }:

let
  # Neovim already ships parsers for c, lua, markdown, markdown_inline, query,
  # vim and vimdoc, so those are intentionally absent here.
  grammars = {
    bash = pkgs.tree-sitter-grammars.tree-sitter-bash;
    cpp = pkgs.tree-sitter-grammars.tree-sitter-cpp;
    go = pkgs.tree-sitter-grammars.tree-sitter-go;
    javascript = pkgs.tree-sitter-grammars.tree-sitter-javascript;
    json = pkgs.tree-sitter-grammars.tree-sitter-json;
    ql = pkgs.tree-sitter-grammars.tree-sitter-ql;
    rust = pkgs.tree-sitter-grammars.tree-sitter-rust;
    yaml = pkgs.tree-sitter-grammars.tree-sitter-yaml;
  };
in
{
  xdg.dataFile = lib.mapAttrs' (
    language: grammar:
    lib.nameValuePair "nvim/site/parser/${language}.so" { source = "${grammar}/parser"; }
  ) grammars;
}
