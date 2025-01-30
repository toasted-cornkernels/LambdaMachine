{ config, lambdaMachineDir, username, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
rec {

  home.sessionPath = [ "/opt/homebrew/bin" ];
  imports = [
    ../common-home.nix

    ../../Common/modules/fzf.nix
    ../../Common/modules/htop.nix
    ../../Common/modules/tmux.nix
    ../../Common/modules/zoxide.nix
    ../../Common/modules/zsh.nix
    ../../Common/modules/starship.nix

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

  home.username = username;
  home.homeDirectory = /Users/${username};

  home.file = {
    ".emacs.d" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/ELispMachine";
    };
    ".hammerspoon" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/FennelMachine";
    };
    ".vimrc" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/VimConfig/.vimrc";
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
