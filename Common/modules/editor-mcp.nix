{ pkgs, ... }:

# MCP server that lets CLI agents drive the user's live Emacs and Neovim.
# See Common/agent-tools/editor-mcp/README.md.
let
  editor-mcp = pkgs.stdenvNoCC.mkDerivation {
    pname = "editor-mcp";
    version = "0.1.0";
    src = ../agent-tools/editor-mcp;
    nativeBuildInputs = [ pkgs.makeWrapper ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share/editor-mcp
      cp editor_mcp.py editor-mcp.el editor-mcp.lua $out/share/editor-mcp/
      makeWrapper ${pkgs.python3}/bin/python3 $out/bin/editor-mcp \
        --add-flags $out/share/editor-mcp/editor_mcp.py
      runHook postInstall
    '';
  };
in
{
  # On PATH so other agents (Claude Code, Codex, ...) can register it too.
  home.packages = [ editor-mcp ];

  home.file.".copilot/mcp-config.json".text = builtins.toJSON {
    mcpServers.editor = {
      type = "local";
      command = "${editor-mcp}/bin/editor-mcp";
      args = [ ];
      tools = [ "*" ];
    };
  };
}
