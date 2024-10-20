{ pkgs, ... }:
let
  aspell-with-dicts =
    pkgs.aspellWithDicts (dict: with dict; [ en en-computers en-science ]);
in { home.packages = [ pkgs.hunspell aspell-with-dicts ]; }

