{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      source ~/.zshenv

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
      ytmp3 = ''
        ${pkgs.yt-dlp} -ic \
                       -o "%(playlist_index)s-%(title)s.%(ext)s" \
                       --yes-playlist \
                       -x \
                       --audio-format mp3 \
                       --audio-quality 0 '';
      mp3 = "${pkgs.mpv} --no-video --quiet";
      mp32 = "${pkgs.mpv} --no-video --really-quiet";
      tmuxlocal = "${pkgs.tmux} attach -t local";
      tmuxssh = "${pkgs.tmux} attach -t ssh";
      fw = "${pkgs.w3m} $(sk)";
      playvideo = "${pkgs.mpv} --no-config --vo=tct ";

      ss = "source ~/.zshrc";
      pfind = "ps -ef | grep -i ";

      ls = "${pkgs.eza} -a";
      sl = "${pkgs.eza} -a";
      la = "${pkgs.eza} -la";
      ll = "${pkgs.eza} -l";

      vi = "${pkgs.vim}";
      vim = "${pkgs.neovim}";
      vs = "${pkgs.neovim} -O";
      sp = "${pkgs.neovim} -o";
      fv = "${pkgs.neovim} $(sk)";
      fvi = "${pkgs.vim} $(sk)";

      emacs = "emacs -nw";
      e = "emacsclient -t";
      ef = "emacsclient $(sk)";

      # TODO These are Darwin-only
      wifi = "networksetup -setairportpower en0";
      wifistatus = "networksetup -getairportpower en0";
      battery = "pmset -g batt";
      ws = "wifistatus; blueutil -p; battery";
    };
  };
}
