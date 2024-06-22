{ ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    sessionVariables = {
      PROMPT="%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# ";
      CLICOLOR = 1;
    };

    initExtraFirst = ''
      # tmux on startup (ssh)
      # This should be at the top!
      if [[ $- == *i* ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
          tmux attach-session -t ssh || tmux new-session -s ssh
      fi

      # tmux on startup (local)
      if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
          tmux new-session -A -s local
      fi
    '';
    initExtra = ''
      if [ -e /home/jslee/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jslee/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

      # opam configuration
      test -r /home/jslee/.opam/opam-init/init.sh && . /home/jslee/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

      # fix zsh slow in git repo
      __git_files () {
          _wanted files expl 'local files' _files
      }

      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    '';
    shellAliases = {
      ytmp3 = ''yt-dlp -ic \
                       -o "%(playlist_index)s-%(title)s.%(ext)s" \
                       --yes-playlist \
                       -x \
                       --audio-format mp3 \
                       --audio-quality 0 '';
      mp3 = "iina --no-video --quiet";
      mp32 = "iina --no-video --really-quiet";
      tmuxlocal = "tmux attach -t local";
      tmuxssh = "tmux attach -t ssh";
      fw = "w3m $(sk)";
      playvideo = "iina --no-config --vo=tct ";

      ss = "source ~/.zshrc";
      pfind = "ps -ef | grep -i ";

      ls = "eza -a";
      sl = "eza -a";
      la = "eza -la";
      ll = "eza -l";

      vi = "$HOME/.nix-profile/bin/vim";
      vim = "$HOME/.nix-profile/bin/nvim";
      vs = "$HOME/.nix-profile/bin/nvim -O";
      sp = "$HOME/.nix-profile/bin/nvim -o";
      fv = "$HOME/.nix-profile/bin/nvim $(sk)";
      fvi = "$HOME/.nix-profile/bin/vim $(sk)";

      emacs = "emacs -nw";
      e = "emacsclient -t";
      ef = "emacsclient $(sk)";

    };
  };
}
