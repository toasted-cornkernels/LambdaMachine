{ pkgs, ... }:

{
  programs.newsboat = {
    enable = true;

    extraConfig = ''
      unbind-key j
      unbind-key k
      unbind-key J
      unbind-key K
      unbind-key n
      unbind-key b
      unbind-key o
      unbind-key r
      unbind-key PPAGE
      unbind-key NPAGE
      unbind-key s

      bind-key j down
      bind-key k up
      bind-key l open
      bind-key h quit
      bind-key J next
      bind-key ^J next
      bind-key K prev
      bind-key ^K prev
      bind-key b open-in-browser
      bind-key r toggle-article-read
      bind-key ^U pageup
      bind-key ^D pagedown
      bind-key G end
      bind-key s set-filter
      '';
  };
}
