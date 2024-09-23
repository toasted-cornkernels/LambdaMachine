{ pkgs, ... }:
{
  home.packages = with pkgs; [
    chez
    gambit
    chicken
    guile
  ];
}
