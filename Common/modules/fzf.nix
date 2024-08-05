{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = ''rg --files --hidden --follow --color=never --glob=\"!**/.git/\"'';
    tmux = {
      enableShellIntegration = true;
    };
  };
}
