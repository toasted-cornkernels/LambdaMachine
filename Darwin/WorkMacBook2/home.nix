{ lib, pkgs, config, lambdaMachineDir, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
rec {
  home.sessionPath = [ "/opt/homebrew/bin" ];

  # Relocate the generated zsh config under ZDOTDIR so that ~/.zshrc stays a
  # plain, writable file. Machine-local provisioning tooling appends to it and
  # cannot write to a read-only store path. Both hooks are optional: the files
  # are untracked and absent on a fresh checkout.
  programs.zsh = {
    dotDir = ".config/zsh";
    envExtra = ''
      [ -r "$HOME/.zshenv.local" ] && . "$HOME/.zshenv.local"
    '';
    initExtra = ''
      [ -r "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"
    '';
  };

  imports = [
    ../common-home.nix

    ../../Common/modules/fzf.nix
    ../../Common/modules/htop.nix
    ../../Common/modules/tmux.nix
    ../../Common/modules/zoxide.nix
    ../../Common/modules/zsh.nix
    ../../Common/modules/starship.nix
    ../../Common/modules/neovim-treesitter.nix

    ../../Common/packages/PL/Go.nix
    ../../Common/packages/PL/Ruby.nix
    ../../Common/packages/PL/Python.nix
    ../../Common/packages/PL/Yaml.nix
    ../../Common/packages/PL/Lua.nix

    ../../Common/packages/Utils/Compress.nix
    ../../Common/packages/Utils/Dev.nix
    ../../Common/packages/Utils/Edit.nix
    ../../Common/packages/Utils/Fonts.nix
    ../../Common/packages/Utils/Mac.nix
    ../../Common/packages/Utils/Search.nix
    ../../Common/packages/Utils/Shell.nix
    ../../Common/packages/Utils/Stats.nix
    ../../Common/packages/Utils/Unix.nix
    ../../Common/packages/Utils/VC.nix
    ../../Common/packages/Utils/Web.nix

    ../programs/zsh.nix
  ];

  home.username = "jlee4430";
  home.homeDirectory = /Users/${home.username};

  # claude-agent-acp only bakes claude-code in as the default value of
  # CLAUDE_CODE_EXECUTABLE. Nixpkgs' claude-code cannot be built on this
  # machine, so point the wrapper at the Homebrew-managed binary instead.
  # Machine-local and impure by design -- it assumes Homebrew's claude.
  home.packages = [
    (pkgs.claude-agent-acp.override {
      claude-code = pkgs.writeShellScriptBin "claude" ''
        exec /opt/homebrew/bin/claude "$@"
      '';
    })
  ];

  home.file = {
    ".emacs.d" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/ELispMachine";
    };
    ".hammerspoon" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/FennelMachine";
    };
    ".vimrc" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/dots/.vimrc";
    };
    ".gvimrc" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/dots/.gvimrc";
    };
  };

  xdg = {
    enable = true;
    configFile = {
      nvim = {
        source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/NeovimConfig";
      };
      ghostty = {
        source = mkOutOfStoreSymlink
          "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/dots/ghostty";
      };
    };
  };
}
