{ pkgs, config, lambdaMachineDir, ... }:
let inherit (config.lib.file) mkOutOfStoreSymlink;
in rec {
  imports = [
    ../../Common/modules/fzf.nix
    ../../Common/modules/htop.nix
    ../../Common/modules/tmux.nix
    ../../Common/modules/zoxide.nix
    ../../Common/modules/zsh.nix
    ../../Common/modules/starship.nix
  ];

  home.username = "jslee";
  home.homeDirectory = /Users/${home.username};

 home.file = {
    ".emacs.d" = {
      source = mkOutOfStoreSymlink "${config.home.homeDirectory}/${lambdaMachineDir}/ExternalConfigs/ELispMachine";
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
    };
  };
}
