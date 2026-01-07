{ pkgs, ... }:
{
  home.packages = with pkgs; [
    abcl
    asdf
    # ecl
    roswell
    sbcl
  ];
}

