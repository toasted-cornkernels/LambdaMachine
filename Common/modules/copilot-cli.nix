{
  config,
  lib,
  pkgs,
  ...
}:

let
  platform = pkgs.stdenv.hostPlatform;

  settings = {
    # Prefer high-capability models.
    model = "auto";
    autoTier = "intelligence";

    # Manage updates through Nix.
    autoUpdate = false;

    # Keyboard-first interface.
    mouse = false;

    # Privacy: do not sync session history to GitHub.
    remoteExport = false;
    remoteSessions = false;

    # Preserve the full toolset and normal approval workflow.
    defaultPermissionMode = "manual";

    # Keep useful interactive features.
    renderMarkdown = true;
    stream = true;
    respectGitignore = true;

    # On-device dictation (/voice).
    # Voice mode supports macOS on Apple silicon and Linux x64 only.
    voice.enabled =
      (platform.isDarwin && platform.isAarch64) || (platform.isLinux && platform.isx86_64);
  };

  settingsFile = pkgs.writeText "copilot-settings.json" (builtins.toJSON settings);
  target = "${config.home.homeDirectory}/.copilot/settings.json";
  jq = "${pkgs.jq}/bin/jq";
in
{
  imports = [ ./editor-mcp.nix ];

  programs.github-copilot-cli = {
    enable = true;
    package = pkgs.github-copilot-cli;
  };

  # The current CLI reads settings.json; Home Manager's settings option still
  # targets config.json. It can't be a home.file symlink: the CLI saves
  # preferences (e.g. /voice) by locking and rewriting the resolved path, which
  # fails in the read-only store. Instead, keep a real file and deep-merge the
  # managed keys into it on each switch, so Nix wins and CLI-written keys stay.
  home.activation.copilotSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    target="${target}"
    run mkdir -p "$(dirname "$target")"
    if [ -L "$target" ]; then
      run rm "$target"
    fi
    if [ -f "$target" ] && ${jq} -e 'type == "object"' "$target" >/dev/null 2>&1; then
      run sh -c '${jq} -s ".[0] * .[1]" "$1" "$2" > "$1.tmp" && mv "$1.tmp" "$1"' \
        _ "$target" "${settingsFile}"
    else
      run install -m 600 "${settingsFile}" "$target"
    fi
  '';
}
