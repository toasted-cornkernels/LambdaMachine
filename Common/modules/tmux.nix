{ pkgs, ... }:
let
  tmux-themepack = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-themepack";
    version = "unstable-2024-03-24";
    src = pkgs.fetchFromGitHub {
      owner = "jimeh";
      repo = "tmux-themepack";
      rev = "7c59902f64dcd7ea356e891274b21144d1ea5948";
      sha256 = "sha256-c5EGBrKcrqHWTKpCEhxYfxPeERFrbTuDfcQhsUAbic4=";
    };
  };

in {
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;
    mouse = true;
    aggressiveResize = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    prefix = "C-a";
    baseIndex = 1;
    historyLimit = 100000;
    escapeTime = 10;
    keyMode = "vi";
    newSession = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
          set -g @yank_action 'copy-pipe'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      {
        plugin = tmux-themepack;
        extraConfig = ''
          source-file "${tmux-themepack}/share/tmux-plugins/tmux-themepack/powerline/block/cyan.tmuxtheme"
        '';
      }
      { plugin = tmuxPlugins.better-mouse-mode; }
      { plugin = tmuxPlugins.copycat; }
      {
        plugin = tmuxPlugins.open;
        extraConfig = ''
          set -g @open-S 'https://www.google.com/search?q='
        '';
      }
    ];
    extraConfig = ''
      # set -g status off

      set-option -g prefix C-a
      unbind-key C-b
      bind-key C-a send-prefix

      setw -g monitor-activity on

      set-option -g renumber-windows on

      bind-key ";" split-window -h -c "#{pane_current_path}"
      bind-key "\'" split-window -v -c "#{pane_current_path}"

      bind-key "=" select-layout tiled

      bind-key : command-prompt
      bind-key r refresh-client
      bind-key L clear-history

      bind-key space next-window
      bind-key enter next-layout

      # use vim-like keys for splits and windows
      bind-key v split-window -h -c "#{pane_current_path}"
      bind-key s split-window -v -c "#{pane_current_path}"
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      bind-key b break-pane
      bind-key r rotate-window
      bind-key C-z resize-pane -Z
      bind-key C-d detach-client

      bind-key - resize-pane -D 10
      bind-key > resize-pane -R 10
      bind-key < resize-pane -L 10
      bind-key = resize-pane -U 10

      unbind-key C-h

      bind-key M-h resize-pane -L 10
      bind-key M-j resize-pane -D 10
      bind-key M-k resize-pane -U 10
      bind-key M-l resize-pane -R 10

      bind-key C-h select-pane -L
      bind-key C-j select-pane -D
      bind-key C-k select-pane -U
      bind-key C-l select-pane -R
      bind-key bspace select-pane -L

      bind-key C-o rotate-window

      set-window-option -g other-pane-height 25
      set-window-option -g other-pane-width 80

      bind-key a last-pane
      bind-key q display-panes
      bind-key . new-window -c "#{pane_current_path}"
      bind-key t next-window
      bind-key T previous-window

      bind-key [ copy-mode
      bind-key C-[ copy-mode
      bind-key ] paste-buffer

      bind-key o copy-mode

      # Setup 'v' to begin selection as in Vim
      bind-key -T edit-mode-vi Up send-keys -X history-up
      bind-key -T edit-mode-vi Down send-keys -X history-down
      unbind-key -T copy-mode-vi Space     ;   bind-key -T copy-mode-vi v send-keys -X begin-selection
      unbind-key -T copy-mode-vi C-v       ;   bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      unbind-key -T copy-mode-vi [         ;   bind-key -T copy-mode-vi [ send-keys -X begin-selection
      unbind-key -T copy-mode-vi ]         ;   bind-key -T copy-mode-vi ] send-keys -X copy-selection

      set -g status-interval 1

      set -g status-left-length 30
      # set-window-option -g mode-keys vi

      setw -g monitor-activity on
      set -g visual-activity off

      # Enable native Mac OS X copy/paste
      set-option -g default-command "/bin/bash -c 'which reattach-to-user-namespace >/dev/null && exec reattach-to-user-namespace $SHELL -l || exec $SHELL -l'"

      set-option -g repeat-time 0
    '';
  };
}
