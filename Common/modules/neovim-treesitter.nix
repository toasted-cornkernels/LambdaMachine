# Tree-sitter parsers for Neovim, provisioned declaratively.
#
# The nvim-treesitter plugin is kept only for its query corpus; parsers come
# from here rather than from :TSInstall, which writes into the data directory
# outside of Nix's control. $XDG_DATA_HOME/nvim/site is on Neovim's default
# 'runtimepath', so these are discovered without any configuration.
#
# Note that the grammars' own queries (upstream ships some under $out/queries)
# are deliberately not linked: their capture names target the tree-sitter CLI
# rather than Neovim, so nvim-treesitter's adapted queries are used instead.
#
# Those queries reference node types by name, so a grammar at the wrong
# revision makes them fail with "Invalid node type". The grammars are hence
# taken from nixpkgs' nvim-treesitter package, which builds each one at the
# revision nvim-treesitter pins, rather than from pkgs.tree-sitter-grammars,
# which follows upstream releases (diff, fennel, kotlin, make, perl, regex,
# scala, sql and xml are all incompatible from there).
#
# The one exception is org, whose queries ship with nvim-orgmode rather than
# nvim-treesitter. Providing it here stops orgmode from compiling its own copy
# into the plugin directory on first use.
{ pkgs, lib, ... }:

let
  inherit (pkgs.vimPlugins.nvim-treesitter) builtGrammars;

  # Neovim language names, which is what the parser files must be called.
  # Only languages nvim-treesitter ships queries for are worthwhile.
  #
  # Neovim already ships parsers for c, lua, markdown, markdown_inline, query,
  # vim and vimdoc, so those are intentionally absent here.
  languages = [
    "agda"
    "bash"
    "bibtex"
    "c_sharp"
    "clojure"
    "cmake"
    "comment"
    "commonlisp"
    "cpp"
    "css"
    "csv"
    "diff"
    "dockerfile"
    "dot"
    "dtd"
    "editorconfig"
    "eex"
    "elixir"
    "fennel"
    "git_config"
    "git_rebase"
    "gitattributes"
    "gitcommit"
    "gitignore"
    "go"
    "gomod"
    "gowork"
    "haskell"
    "heex"
    "html"
    "http"
    "ini"
    "janet_simple"
    "java"
    "javascript"
    "jsdoc"
    "json"
    "kotlin"
    "latex"
    "luadoc"
    "luap"
    "make"
    "mermaid"
    "nim"
    "nix"
    "ocaml"
    "ocaml_interface"
    "ocamllex"
    "org"
    "perl"
    "printf"
    "python"
    "ql"
    "racket"
    "regex"
    "rst"
    "ruby"
    "rust"
    "scala"
    "scheme"
    "sql"
    "ssh_config"
    "starlark"
    "toml"
    "tsv"
    "tsx"
    "typescript"
    "xml"
    "yaml"
    "zsh"
  ];

  # Grammars whose nvim-treesitter queries, at the commit pinned in
  # NeovimConfig/nvim-pack-lock.json, need a newer revision than nixpkgs builds.
  # Revisions are from that commit's lua/nvim-treesitter/parsers.lua; drop an
  # entry once nixpkgs catches up.
  pinned = {
    diff = {
      owner = "tree-sitter-grammars";
      repo = "tree-sitter-diff";
      rev = "ada384ac7bfc1307f32de474620120add29998fb";
      hash = "sha256-5HCBFE/99DJ9AYWSk18WRF3RGQpgpYAYA37bT54F0DI=";
    };
    kotlin = {
      owner = "fwcd";
      repo = "tree-sitter-kotlin";
      rev = "1852ea17b7f60fb3f9d84e0b1555d56b46b39fb1";
      hash = "sha256-7pFQyuRy2tJTL8g3zi6Q1W4AzaNpucu09lae4lmBEyE=";
    };
    # Tag 2.0.4: the exact version nvim-orgmode's installer requires. Any other
    # version makes orgmode warn on startup.
    org = {
      owner = "nvim-orgmode";
      repo = "tree-sitter-org";
      rev = "f15da8e8fcb3a2d764c7092ae6ba4dc87d3b3093";
      hash = "sha256-76ImC8GMW+yAKG++AHryUi+MYTmtJ5ogygC+bgNMErA=";
    };
    scala = {
      owner = "tree-sitter";
      repo = "tree-sitter-scala";
      rev = "db390f312a54b04b13790e1767bfac32665c17ac";
      hash = "sha256-3RVv9bI0KUBWehf2+x9ZRHFrfUabyq2zK/G3SjNdAes=";
    };
  };

  grammarFor =
    language:
    if pinned ? ${language} then
      pkgs.tree-sitter.buildGrammar {
        inherit language;
        version = "0.0.0+rev=${builtins.substring 0 7 pinned.${language}.rev}";
        src = pkgs.fetchFromGitHub pinned.${language};
      }
    else
      builtGrammars.${language};
in
{
  xdg.dataFile = lib.listToAttrs (
    map (
      language:
      lib.nameValuePair "nvim/site/parser/${language}.so" { source = "${grammarFor language}/parser"; }
    ) languages
  );
}
