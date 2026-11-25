{ pkgs, ... }:

let
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
  };
in
{
  programs.github-copilot-cli = {
    enable = true;
    package = pkgs.github-copilot-cli;
  };

  # The current CLI reads settings.json.
  # Home Manager's settings option still targets config.json.
  home.file.".copilot/settings.json".text = builtins.toJSON settings;
}
