{ ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "emacs";
    history = {
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreAllDups = true;
      size = 10000;
      save = 10000;
      share = true;
      extended = true;
    };
    enableCompletion = true;
    completionInit = ''
      autoload -U compinit && compinit
      autoload zmv
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';
    syntaxHighlighting = { enable = true; };
    initExtra = ''
      if [ -e /home/jslee/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jslee/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

      # opam configuration
      test -r /home/jslee/.opam/opam-init/init.sh && . /home/jslee/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

      # fix zsh slow in git repo
      __git_files () {
          _wanted files expl 'local files' _files
      }

      export PROMPT="%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# "
      export CLICOLOR=1

      [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    '';
    shellAliases = {
      ytmp3 = ''
        yt-dlp -ic \
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
